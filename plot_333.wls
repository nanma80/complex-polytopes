#!/usr/bin/env wolframscript

(*
mogrify -crop 450x450+75+0 -path . pov_*.png
mogrify -crop 300x300+50+0 -path . explode*.gif

magick convert -delay 5 -dispose 2 *.png out.gif
magick convert out.gif -coalesce -duplicate 1,-2-1 -quiet -layers OptimizePlus  -loop 0 cycle.gif
python -m SimpleHTTPServer 8000

*)

(* global config *)

(* shapes = {
	"test",
	"polytope_5_3_3",
	"polytope_3_3_5",
	"polytope_3_5_52",
	"polytope_52_5_3",
	"polytope_5_52_5",
	"polytope_5_3_52",
	"polytope_52_3_5",
	"polytope_52_5_52",
	"polytope_5_52_3",
	"polytope_3_52_5",
	"polytope_3_3_52",
	"polytope_52_3_3"
}
 *)
(*shape = "test";*)
shapes = {
	(* "test", *)
	"polytope_3_3_4"
};


exportToPov = True;
dataFolder = "data";
imageFolder = "output";

imageSizes = <|
	"allLayers" -> {1000, 750}, (* must be 4:3 *)
	"singleLayer" -> {600, 450} (* must be 4:3 *)
|>;

allColors = <|
	"4_3" -> Red,
	"3_4" -> Green,
	"3_3" -> Cyan,
	"5_3" -> Red,
	"3_5" -> Green,
	"52_5" -> Blue,
	"5_52" -> Yellow,
	"52_3" -> Magenta,
	"3_52" -> Orange
|>;

(* shape -> {maxExplosionFactor, frameCount}*)
explosionConfigs = <|
	(* 120-cell *)
	"polytope_5_3_3" -> {2.0, 30},

	(* 600-cell *)
	"polytope_3_3_5" -> {2.0, 30},

	(* Icosahedral 120-cell. cell: icosahedron *)
	"polytope_3_5_52" -> {2.0, 30},

	(* Small stellated 120-cell. cell: {5/2, 5}. Small stellated dodecahedron *)
	"polytope_52_5_3" -> {2.0, 30},

	(* Great 120-cell. cell: {5, 5/2}. Great dodecahedron. Self dual *)
	"polytope_5_52_5" -> {2.0, 30},

	(* Grand 120-cell. cell: {5, 3}. Dodecahedron *)
	"polytope_5_3_52" -> {2.0, 30},

	(* Great stellated 120-cell. cell: great stellated dodecahedron *)
	"polytope_52_3_5" -> {2.0, 30},

	(* Grand stellated 120-cell. cell: {5/2, 5}. Small stellated dodecahedron. Self dual *)
	"polytope_52_5_52" -> {2.0, 30},

	(* Great grand 120-cell. cell: Great dodecahedron *)
	"polytope_5_52_3" -> {2.0, 30},

	(* Greate icosahedral 120-cell. cell: great icosahedron *)
	"polytope_3_52_5" -> {2.0, 30},

	(* Grand 600-cell. cell: tetrahedron, 600 cells *)
	"polytope_3_3_52" -> {2.0, 30},

	(* Great grand stellated 120-cell. cell: great stellated dodecahedron *)
	"polytope_52_3_3" -> {2.0, 30},

	"polytope_4_3_3" -> {2.0, 30},

	"polytope_3_3_4" -> {2.0, 30},

	"polytope_3_4_3" -> {2.0, 30},

	"test" -> {2.0, 3}
|>

rangeFactor = 0.8;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

getProjectionMatrix[direction_] := Simplify[Orthogonalize[{direction, {0.3, 510.234, 0.5, 0}, {0, 0.2, 1000, 0}, {0, 1.3, 0, -1000}}]][[2;;4]];
getProjectionMatrix2[direction_, direction2_] := Simplify[Orthogonalize[{direction, {0, 10, 0,  1}, direction2, {-3, 3, -5, 0}}]][[2;;4]];
projectToDirection[vertex4d_, projectionMatrix_] := projectionMatrix.vertex4d;
projectTo3d[vertex4d_] := {vertex4d[[1]], vertex4d[[2]], vertex4d[[3]]};
reflect[point_, mirror_] := FullSimplify[point - 2 * (point.mirror)/(mirror.mirror)*mirror];
doubleReflect[point_, mirror1_, mirror2_] := reflect[reflect[point, mirror1], mirror2];
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
explodedFace[face_, explosionFactor_] := Map[(# + Mean[face] * explosionFactor)&, face];
sameVertex[point1_, point2_] := point1 == point2;
sameCenter[edge1_, edge2_] := Total[edge1] == Total[edge2];
sameCellCenter[cell1_, cell2_] := getCellCenter[cell1] == getCellCenter[cell2];
getFaceCenter[face_] := Simplify[Total[face]];
getCellCenter[cell_] := Simplify[Total[Flatten[cell, 1]]];
explodedFace[face_, explosionFactor_] := Map[(# + Mean[face] * explosionFactor)&, face];
explodedCell[cell_, explosionFactor_] := Map[
	(# + Mean[Map[Mean,cell]]*(Norm[First[First[cell]]//N]/Norm[Mean[Map[Mean,cell]]//N])^1.5 * explosionFactor)&, 
	cell, {2}];

exportImage[shape_, theta_, phi3d_, serialNumber_, frameFolder_] := Module[
	{
		dataFileName,
		shapeTokens,
		color,
		cellShape,
		cells,
		cellsByLayers,
		layerKeys,
		thickness,
		lighting,
		outputFolder,
		range,
		outputFileName,
		cropCommand,
		inactiveCells,
		inactiveFaces,
		inactiveEdges,
		inactiveVertices,
		activeCells,
		activeFaces,
		touchingIndices,
		notTouchingIndices,
		touchingActiveFaces,
		notTouchingActiveFaces,
		allIndices,
		activeEdges,
		activeVertices,
		graph,
		imageSize,
		i,
		vertex
	},

	dataFileName = FileNameJoin[{dataFolder, shape <> ".wl"}];
	Print["Reading data for " <> shape <> " from " <> dataFileName];
	shapeTokens = StringSplit[shape, "_"];
	If[Length[shapeTokens] < 3,
		color = Red,
		cellShape = shapeTokens[[2]] <> "_" <> shapeTokens[[3]];
		color = allColors[cellShape];
	];

	cells = Get[dataFileName];
	Print["There are " <> IntegerString[Length[cells]] <> " cells in total."];

	thickness = Norm[cells[[1]][[1]][[1]]] * 0.008;
	lighting = {{"Point", White, {10, -10, 10}}};
	range = Norm[cells[[1]][[1]][[1]]] * rangeFactor;
	
	outputFolder = FileNameJoin[{imageFolder, frameFolder}];
	If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

	outputFileName = "animation_frame_" <> IntegerString[serialNumber, 10, 4] <> ".png";
	outputFileName = FileNameJoin[{outputFolder, outputFileName}];

	imageSize = imageSizes["allLayers"];
	cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

	selectTotal = {{0, -1, 1, 1}, {1, 0, -1, 1}, {-1, 1, 0, 1}, {1, 1, 1, 0}, {-1, -1, -1, 0}, {-1, 0, 1, -1}, {1, -1, 0, -1}, {0, 1, -1, -1}};

	allFaces = Union[ Flatten[cells, 1], SameTest -> sameCenter];

	complexEdges = Select[allFaces, MemberQ[selectTotal, Total[#]]&];
	allVertices = Union[ Flatten[complexEdges, 1], SameTest -> sameVertex];

	Print[IntegerString[Length[allFaces]] <> " faces in the original polytope. " <> IntegerString[Length[complexEdges]] <> " are selected as complex edges."];
	Print[IntegerString[Length[allVertices]] <> " vertices in total. "];

	edgeCounts = {};
	For[i=1, i<=Length[allVertices], i++,
		vertex = allVertices[[i]];
		edgeCountContainingVertex = Length[Select[complexEdges, MemberQ[#, vertex]&]];
		AppendTo[edgeCounts, edgeCountContainingVertex];
	];
	uniqueEdgeCounts = Union[edgeCounts];
	If[Length[uniqueEdgeCounts] == 1, 
		Print["Every vertex belongs to " <> IntegerString[uniqueEdgeCounts[[1]]] <> " complex edges."],
		Print["The complex polytope is not regular. The edge counts are " <> ToString[edgeCounts]];
	];

	viewVertical = {0, 0, 1};
	projectionVector4D = {-Sin[theta]/5, 0,  - Sin[theta], Cos[theta]};
	projectionTo3D = getProjectionMatrix[projectionVector4D];
	(* projectionTo3D = getProjectionMatrix2[{1, 1, 0, 0}, {1, 0, 0, 0}]; *)
	(* projectionTo3D = IdentityMatrix[4][[1;;3]]; *)
	projectionMatrix = RotationMatrix[- phi3d, viewVertical].projectionTo3D;

	positiveEdges = Select[complexEdges, Total[#].projectionVector4D >= 0 &];
	negativeEdges = Select[complexEdges, Total[#].projectionVector4D < 0 &];
	Print[{Length[positiveEdges], Length[negativeEdges]}];

	graph = Graphics3D[
		{
			{
				Opacity[0.8], FaceForm[Red], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
			},

			{
				Opacity[0.3], FaceForm[Blue], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, negativeEdges, {2}]]
			},

			{
				FaceForm[Yellow], Map[Sphere[#, thickness * 4]&, Map[projectToDirection[#, projectionMatrix]&, allVertices]]
			}
		},
		ViewVertical -> viewVertical,
		ViewPoint -> {3, -4, 2}*3,
		PlotRange -> {{-range, range}, {-range, range}, {-range, range}},
		Lighting -> lighting
	];


	If[exportToPov,
		If[FileExistsQ[outputFileName], DeleteFile[outputFileName]];
		POVRayRender[graph, Method -> "Triangle", OutputPath -> outputFileName, ImageSize -> imageSize, RenderOptions -> "+A0.001 -J +UA"];
		Run[cropCommand];
		,
		Export[outputFileName, graph];
	]
	Print["Saved the image to " <> outputFileName];
]

exportAnimation[shape_, frameCount_] := Module[
	{
		outputFolder,
		gifFileName,
		gifFolder,
		explosionConfig,
		maxExplosionFactor,
		frameIndex,
		explosionFactor,
		gifCommand
	},

	frameFolder = shape <> "_frames_0";
	outputFolder = FileNameJoin[{imageFolder, frameFolder}];
	If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

	gifFileName = shape <> "_0";
	gifFolder = FileNameJoin[{imageFolder, shape}];
	If[!DirectoryQ[gifFolder], CreateDirectory[gifFolder]];


    epsilon = 0.001;
    maxTheta = Pi / 6 - epsilon 2;
    thetaStep = (maxTheta )/frameCount;

    thetas = Join[
        Table[epsilon, {k, Floor[frameCount / 6]}]
        , Table[k, {k, epsilon, maxTheta + epsilon, thetaStep}]
        (* , Table[maxTheta + epsilon, {k, Floor[frameCount / 6]}] *)
        (* , Table[k, {k, maxTheta + epsilon, epsilon, -thetaStep}] *)
    ];

    maxPhi3d = Pi / 8;
    phi3dStep = maxPhi3d/Length[thetas];
    phi3ds = Table[k, {k, 0, maxPhi3d - phi3dStep, phi3dStep}];

    For[ frameIndex = 1, frameIndex <= Length[thetas] , frameIndex++,
        theta = thetas[[frameIndex]];
        phi3d = phi3ds[[frameIndex]];
        Print["Frame #" <> IntegerString[frameIndex] <> "/" <> IntegerString[Length[thetas]] 
            <> " ; theta: " <> ToString[theta, InputForm] 
            <> " ; phi3d: " <> ToString[phi3d, InputForm]];
        exportImage[shape, theta, phi3d, frameIndex, frameFolder];
    ];

	(* loop back*)
    gifCommand = "magick convert -duplicate 1,-2-1 -quiet +repage -alpha remove -loop 0 -delay "  
    (* no looping back *)
    (* gifCommand = "magick convert -quiet +repage -alpha remove -loop 0 -delay "  *)
        <> IntegerString[Floor[150/frameCount]] <> " -dispose 2 " 
        <> outputFolder <> "\\*animation_frame*.png " 
        <> gifFolder <> "\\" <> gifFileName <> ".gif";

    mp4Command = "ffmpeg -i " <> gifFolder <> "\\" <> gifFileName <> ".gif" 
    	<> " -movflags faststart -pix_fmt yuv420p -vf \"scale=trunc(iw/2)*2:trunc(ih/2)*2\" "
    	<> gifFolder <> "\\" <> gifFileName <> ".mp4";

    Print[gifCommand];
    Run[gifCommand];
    Print["Saved the animation to " <> gifFolder <> "\\" <> gifFileName <> ".gif"];

    Run["rm " <> gifFolder <> "\\" <> gifFileName <> ".mp4"];
    Print[mp4Command];
    Run[mp4Command];
    Print["Saved the video to " <> gifFolder <> "\\" <> gifFileName <> ".mp4"];
];


exportAnimation[shapes[[1]], 36];

(* exportImage[shapes[[1]], 0, 0, 1, "test"]; *)
(* exportImage[shapes[[1]], 0.1, 0, 2, "test"]; *)


