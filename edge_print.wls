#!/usr/bin/env wolframscript

symbols = {
    {3, 4, 2}
    , {2, 4, 3}
    , {4, 4, 2}
    , {2, 4, 4}
    , {5, 4, 2}
    , {2, 4, 5}
    , {6, 4, 2}
    , {2, 4, 6}

    , {3, 3, 3}

    , {3, 6, 2}
    , {2, 6, 3}

    , {3, 4, 3}
    , {4, 3, 4}

    , {3, 8, 2}
    , {2, 8, 3}

    , {4, 6, 2}
    , {2, 6, 4}

    , {4, 4, 3}
    , {3, 4, 4}

    , {3, 5, 3}

    , {5, 3, 5}

    , {3, 10, 2}
    , {2, 10, 3}

    , {5, 6, 2}
    , {2, 6, 5}

    , {5, 4, 3}
    , {3, 4, 5}
    
    (* starry *)
    , {3, 3, 2}
    , {3, 5/2, 3}
    , {5, 5/2, 5}
    , {5, 3, 2}
};

symbols = { {3, 6, 2} };

exportToPov = False;
dataFolder = "data";
imageFolder = "output";

imageSize = {600, 450};

rangeFactor = 1.0;

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

(* barycenter of a polygon *)
averagepoints[points_?MatrixQ] :=
        Mean[If[TrueQ[First[points] == Last[points]], Most, Identity][points]];

(* Newell's algorithm for face normals *)
newellNormals[pts_?MatrixQ] := Module[{tp = Transpose[pts]}, Normalize[MapThread[Dot,
              {RotateLeft[ListConvolve[{{-1, 1}}, tp, {-1, -1}]], 
               RotateRight[ListConvolve[{{1, 1}}, tp, {-1, -1}]]}]]];

thickenaux[points_, thick_] := Module[{center = averagepoints[points],
  nrm = newellNormals[points], outerpoints, radialpoints}, 
  outerpoints = Map[TranslationTransform[thick nrm], points];
  radialpoints = MapThread[Join[#1, Reverse[#2]] &,
                           Map[Partition[#, 2, 1, 1] &, {points, outerpoints}]];
  Flatten[{Polygon[Reverse[points]], Polygon /@ radialpoints, Polygon[outerpoints]}]];

ThickenPolygons[shape_, thick_: 0.04] :=
       shape /. Polygon[p_?MatrixQ] :> thickenaux[p, thick];

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

    Print[Directory[]];

	shape = getShapeName[symbol];
	shapeFile = getFileName[symbol];

	dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

	Print["Reading data for " <> shape <> " from " <> dataFileName];

	dataObject = Get[dataFileName];

	realVertices = dataObject[["rotatedRealVertices"]];
	realEdges = dataObject[["rotatedRealEdges"]];

    edgeCenter = Total[realEdges[[1]]]/Length[realEdges[[1]]];
    projectionVector4D = edgeCenter + {0.001, 0.0013, 0.0061, 0.0021};
    (* special adjustment for 362 *)
    projectionVector4D = projectionVector4D + {1, 1, 1, 1} / 3;
    projectionTo3D = getProjectionMatrix[projectionVector4D];

    viewVertical = {0, 0, 1};

    If[Length[realEdges[[1]]] == 2,
        viewVertical = projectToDirection[(realEdges[[1]][[1]] - edgeCenter), projectionTo3D],
        vector1 = projectToDirection[(realEdges[[1]][[1]] - edgeCenter), projectionTo3D];
        vector2 = projectToDirection[(realEdges[[1]][[2]] - edgeCenter), projectionTo3D];
        viewVertical = Orthogonalize[{vector1, vector2, {0.3, 510.234, 0.5}}][[3]]
    ];
    

	Print["Vertex count: " <> IntegerString[Length[realVertices]] <> " Edge count: " <> IntegerString[Length[realEdges]] ];

	thickness = Norm[realVertices[[1]]] * 0.02;
	lighting = {{"Point", White, {10, -10, 10}}};
	range = Norm[realVertices[[1]]] * rangeFactor;

	outputFolder = FileNameJoin[{imageFolder, frameFolder}];
	If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

	outputFileName = shapeFile <> "_animation_frame_edgeFirst_print" <> IntegerString[serialNumber, 10, 4] <> ".png";
	outputFileName = FileNameJoin[{outputFolder, outputFileName}];

	cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;
	(* projectionTo3D = IdentityMatrix[4][[1;;3]].RotationMatrix[{{1, 0.000001, 0.0000061, 0.0000021}, {1, 0, 0, 0}}]; *)

    projectionMatrix = RotationMatrix[- phi3d, {0, 0, 1}].RotationMatrix[{viewVertical, {0, 0, 1}}].projectionTo3D;
    
    graphElements = {
        {
            FaceForm[Yellow], Map[Sphere[#, thickness * 3]&, Map[projectToDirection[#, projectionMatrix]&, realVertices]]
        }
    };

    (* normally -0.1 *)
    positiveEdgesThreshold = - 1.1;
    positiveEdges = Select[realEdges, Total[#].projectionVector4D/Norm[Total[#]]/Norm[projectionVector4D] >= positiveEdgesThreshold &];
    negativeEdges = Select[realEdges, Total[#].projectionVector4D/Norm[Total[#]]/Norm[projectionVector4D] < positiveEdgesThreshold &];

    Print[{Length[positiveEdges], Length[negativeEdges]}];

    positiveEdgesEdges = Flatten[Map[getEdgesFromFace, positiveEdges], 1];
    negativeEdgesEdges = Flatten[Map[getEdgesFromFace, negativeEdges], 1];

    If[Length[realEdges[[1]]] > 2,     
        graphElements = Union[graphElements, 
            {
                {
                    Opacity[1], FaceForm[{Lighter[Red, 0.1]}], Map[ThickenPolygons[Polygon[#], thickness]&, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
                },
                {
                    Opacity[1], FaceForm[{Lighter[Red, 0.1]}], Map[ThickenPolygons[Polygon[Reverse[#]], thickness]&, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
                },

                {
                    FaceForm[Red], Map[Cylinder[#, 2 * thickness]&, Map[projectToDirection[#, projectionMatrix]&, positiveEdgesEdges, {2}]]
                },

(*                 {
                    Opacity[0.5], FaceForm[Blue], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, negativeEdges, {2}]]
                }, *)
                {
                    FaceForm[Blue], Map[Cylinder[#, 2 * thickness]&, Map[projectToDirection[#, projectionMatrix]&, negativeEdgesEdges, {2}]]
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
        ViewVertical -> {0, 0, 1},
		ViewPoint -> {2, -2, 1}*3,
		PlotRange -> {{-range, range}, {-range, range}, {-range, range}},
		Lighting -> lighting
	];


    stlFileName = shapeFile <> "_edgeFirst_print" <> IntegerString[serialNumber, 10, 4] <> ".stl";
    stlFileName = FileNameJoin[{outputFolder, stlFileName}];

    Export[stlFileName, graph];
    Print["Saved the STL to " <> stlFileName]; 

	If[exportToPov,
		If[FileExistsQ[outputFileName], DeleteFile[outputFileName]];
		POVRayRender[graph, Method -> "Triangle", OutputPath -> outputFileName, ImageSize -> imageSize, RenderOptions -> "+A0.001 -J +UA"];
		Run[cropCommand];
		,
		Export[outputFileName, graph];
	]
	Print["Saved the image to " <> outputFileName]; 
]

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];
    exportImage[symbol, 0, 0, 1, getFileName[symbol]];
];


