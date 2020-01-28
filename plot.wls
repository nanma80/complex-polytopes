#!/usr/bin/env wolframscript

symbols = {
    (* {3, 3, 3} *)
    (* , {3, 5, 3} *)
	(* , {4, 4, 2} *)
    (* , {3, 4, 3} *)
    (* , {5, 4, 2} *)
    (* , {2, 4, 5} *)
    (* , {3, 6, 2} *)
    (* , {3, 3, 2} *)
    (* , {3, 5/2, 3} *)
    (* , {5, 3, 2} *)
    (* , {5, 6, 2} *)
    {5, 4, 3}
};


exportToPov = True;
dataFolder = "data";
imageFolder = "output";

imageSize = {600, 450};

rangeFactor = 0.8;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];

getProjectionMatrix[direction_] := Simplify[Orthogonalize[{direction, {0.3, 510.234, 0.5, 0}, {0, 0.2, 1000, 0}, {0, 1.3, 0, -1000}}]][[2;;4]];
getProjectionMatrix2[direction_, direction2_] := Simplify[Orthogonalize[{direction, {0, 10, 0,  1}, direction2, {-3, 3, -5, 0}}]][[2;;4]];
projectToDirection[vertex4d_, projectionMatrix_] := projectionMatrix.vertex4d;
projectTo3d[vertex4d_] := {vertex4d[[1]], vertex4d[[2]], vertex4d[[3]]};
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameVertex[point1_, point2_] := point1 == point2;
sameCenter[edge1_, edge2_] := Total[edge1] == Total[edge2];
sameCellCenter[cell1_, cell2_] := getCellCenter[cell1] == getCellCenter[cell2];
getFaceCenter[face_] := Simplify[Total[face]];
getCellCenter[cell_] := Simplify[Total[Flatten[cell, 1]]];

exportImage[symbol_, theta_, phi3d_, serialNumber_, frameFolder_] := Module[
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
		i,
		vertex
	},

	shape = getShapeName[symbol];
	shapeFile = getFileName[symbol];

	dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

	Print["Reading data for " <> shape <> " from " <> dataFileName];

	dataObject = Get[dataFileName];

	edges = dataObject[["edges"]];
	vertices = dataObject[["vertices"]];

	Print["Vertex count: " <> IntegerString[Length[vertices]] <> " Edge count: " <> IntegerString[Length[edges]] ];

	realVertices = Map[getReal, vertices];
	realEdges = Map[getReal, edges, {2}];

	thickness = Norm[vertices[[1]]] * 0.01;
	lighting = {{"Point", White, {10, -10, 10}}};
	range = Norm[vertices[[1]]] * rangeFactor;

	outputFolder = FileNameJoin[{imageFolder, frameFolder}];
	If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

	outputFileName = shapeFile <> "_animation_frame_vertexFirst_" <> IntegerString[serialNumber, 10, 4] <> ".png";
	outputFileName = FileNameJoin[{outputFolder, outputFileName}];

	cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

	(* projectionVector4D = {Cos[theta], -Sin[theta]/5, 0,  - Sin[theta]}; *)
    projectionVector4D = realEdges[[1]][[1]] + {0.000001, 0, 0.0000061, 0.0000021};

	projectionTo3D = getProjectionMatrix[projectionVector4D];
	(* projectionTo3D = getProjectionMatrix2[{1, 1, 0, 0}, {1, 0, 0, 0}]; *)
	(* projectionTo3D = IdentityMatrix[4][[1;;3]]; *)

    firstProjectionTo3D = Map[projectToDirection[#, projectionTo3D]&, realVertices];
    maxNorm = 0;
    maxVertexIndex = -1;
    For[vertexIndex = 1, vertexIndex <= Length[firstProjectionTo3D], vertexIndex++,
        If[maxNorm < Norm[firstProjectionTo3D[[vertexIndex]]],
            maxNorm = Norm[firstProjectionTo3D[[vertexIndex]]];
            maxVertexIndex = vertexIndex
        ];
    ];

    Print[maxNorm];
    Print[maxVertexIndex];

    viewVertical = firstProjectionTo3D[[maxVertexIndex]];
    Print[viewVertical];


	projectionMatrix = RotationMatrix[- phi3d, {0, 0, 1}].RotationMatrix[{viewVertical, {0, 0, 1}}].projectionTo3D;
    (* projectionMatrix = RotationMatrix[- phi3d, viewVertical].projectionTo3D; *)
    
    graphElements = {
        {
            FaceForm[Yellow], Map[Sphere[#, thickness * 3]&, Map[projectToDirection[#, projectionMatrix]&, realVertices]]
        }
    };

    positiveEdges = Select[realEdges, Total[#].projectionVector4D >= - 0.1 &];
    negativeEdges = Select[realEdges, Total[#].projectionVector4D < - 0.1 &];
    Print[{Length[positiveEdges], Length[negativeEdges]}];

    If[Length[realEdges[[1]]] > 2,     
        graphElements = Union[graphElements, 
            {
                {
                    Opacity[1], FaceForm[Red], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
                },
                {
                    Opacity[0.5], FaceForm[Blue], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, negativeEdges, {2}]]
                }
            }
        ]
        ,
        graphElements = Union[graphElements,
            {
                {
                    Opacity[1], FaceForm[Red], Map[Cylinder[#, thickness * 2]&, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
                },
                {
                    Opacity[0.5], FaceForm[Blue], Map[Cylinder[#, thickness * 2]&, Map[projectToDirection[#, projectionMatrix]&, negativeEdges, {2}]]
                }
            }
        ]

    ];

	graph = Graphics3D[
        graphElements,
		(* ViewVertical -> viewVertical, *)
        ViewVertical -> {0, 0, 1},
		ViewPoint -> {3, -3, 1}*3,
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

exportAnimation[symbol_, frameCount_] := Module[
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

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];

	frameFolder = shapeFile <> "_frames_vertexFirst";
	outputFolder = FileNameJoin[{imageFolder, frameFolder}];
	If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

	gifFileName = shapeFile <> "_vertexFirst";
	gifFolder = FileNameJoin[{imageFolder, shapeFile}];
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

    maxPhi3d = Pi / 2;
    phi3dStep = maxPhi3d/Length[thetas];
    phi3ds = Table[k, {k, 0, maxPhi3d - phi3dStep, phi3dStep}];

    For[ frameIndex = 1, frameIndex <= Length[thetas] , frameIndex++,
        theta = thetas[[frameIndex]];
        phi3d = phi3ds[[frameIndex]];
        Print["Frame #" <> IntegerString[frameIndex] <> "/" <> IntegerString[Length[thetas]] 
            <> " ; theta: " <> ToString[theta, InputForm] 
            <> " ; phi3d: " <> ToString[phi3d, InputForm]];
        exportImage[symbol, theta, phi3d, frameIndex, frameFolder];
    ];

	(* loop back*)
    gifCommand = "magick convert -duplicate 1,-2-1 -quiet +repage -alpha remove -loop 0 -delay "  
    (* no looping back *)
    (* gifCommand = "magick convert -quiet +repage -alpha remove -loop 0 -delay "  *)
        <> IntegerString[Floor[250/frameCount]] <> " -dispose 2 " 
        <> outputFolder <> "\\*animation_frame*.png " 
        <> gifFolder <> "\\" <> gifFileName <> ".gif";

    mp4Command = "ffmpeg -i " <> gifFolder <> "\\" <> gifFileName <> ".gif" 
    	<> " -movflags faststart -pix_fmt yuv420p -vf \"scale=trunc(iw/2)*2:trunc(ih/2)*2\" "
    	<> gifFolder <> "\\" <> gifFileName <> ".mp4";

    Print[gifCommand];
    Run[gifCommand];
    Print["Saved the animation to " <> gifFolder <> "\\" <> gifFileName <> ".gif"];

    Run["del " <> gifFolder <> "\\" <> gifFileName <> ".mp4"];
    Print[mp4Command];
    Run[mp4Command];
    Print["Saved the video to " <> gifFolder <> "\\" <> gifFileName <> ".mp4"];
];

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];
    (* exportAnimation[symbols[[symbolIndex]], 72]; *)
    (* exportImage[symbol, 0, 0, 1, "static_test"]; *)
    exportImage[symbol, 0, Pi/4, 2, "static_test"];
];

(* exportImage[shapes[[1]], 0.1, 0, 2, "test"]; *)


