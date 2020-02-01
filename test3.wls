#!/usr/bin/env wolframscript

exportToPov = True;
dataFolder = "data";
imageFolder = "output";
frameFolder = "static_test";
imageSize = {600, 450};

rangeFactor = 0.8;
phi3d = 0;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

cubeVertices[dimension_] := 2 * Map[IntegerDigits[#, 2][[2;;dimension+1]]&, Table[k, {k, 2^dimension, 2 * 2^dimension - 1}]] - 1;
allPlusMinus[v_] := Union[Map[(v #)&, cubeVertices[Length[v]]]];
getEdge[index_, vertices_] := Map[vertices[[#]]&, index];
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

getTriangularFaces[vertices_] := Module[
    {edgeLength, i, j, k},
    faces = {};
    edgeLength = 10^10;
    For[i = 2, i < Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];

    For[i = 1, i <= Length[vertices]-2, i++, 
        For[j = i + 1, j <= Length[vertices]-1, j++, 
            If[Norm[vertices[[i]] - vertices[[j]]] == edgeLength,
                For[k = j + 1, k <= Length[vertices], k++,
                    If[Norm[vertices[[i]] - vertices[[k]]] == edgeLength 
                        && Norm[vertices[[j]] - vertices[[k]]] == edgeLength,
                        AppendTo[faces, {i, j, k}];
                    ];
                ];   
            ];
        ];
    ];
    faces
];

a = Sqrt[1 + Sqrt[3]/2];
realVertices = {
    {a, -a, -1, 0},
    {1, -a, 0, a},
    {0, -a, -a, 1},
    {a, -1, 0, -a},
    {a, 0, 1, a},
    {a, 0, -a, -1},
    {0, -1, a, a},
    {-a, -1, -a, 0},
    {-1, 0, -a, a},
    {0, -a, 1, -a},
    {a, a, 0, 1},
    {-1, -a, a, 0},
    {1, a, -a, 0},
    {-a, -a, 0, -1},
    {0, a, -1, a},
    {1, 0, a, -a},
    {a, 1, a, 0},
    {0, 1, -a, -a},
    {-a, 0, a, 1},
    {-a, 0, -1, -a},
    {-a, 1, 0, a},
    {0, a, a, -1},
    {-1, a, 0, -a},
    {-a, a, 1, 0}
};

(* vertex1 = {2, 1, 1, 0};
perms = Permutations[vertex1];
realVertices = Flatten[Map[allPlusMinus, perms], 1];
 *)
edgeIndices = getTriangularFaces[realVertices];
realEdges = Map[getEdge[#, realVertices]&, edgeIndices];

edgeCenter = Total[realEdges[[1]]]/Length[realEdges[[1]]];
projectionVector4D = edgeCenter + {0.001, 0.0013, 0.0061, 0.0021};
projectionTo3D = getProjectionMatrix[projectionVector4D];

viewVertical = {0, 0, 1};

If[Length[realEdges[[1]]] == 2,
    viewVertical = projectToDirection[(realEdges[[1]][[1]] - edgeCenter), projectionTo3D],
    vector1 = projectToDirection[(realEdges[[1]][[1]] - edgeCenter), projectionTo3D];
    vector2 = projectToDirection[(realEdges[[1]][[2]] - edgeCenter), projectionTo3D];
    viewVertical = Orthogonalize[{vector1, vector2, {0.3, 510.234, 0.5}}][[3]]
];


Print["Vertex count: " <> IntegerString[Length[realVertices]] <> " Edge count: " <> IntegerString[Length[realEdges]] ];

thickness = Norm[realVertices[[1]]] * 0.01;
lighting = {{"Point", White, {10, -10, 10}}};
range = Norm[realVertices[[1]]] * rangeFactor;

outputFolder = FileNameJoin[{imageFolder, frameFolder}];
If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

outputFileName = "test3.png";
outputFileName = FileNameJoin[{outputFolder, outputFileName}];

cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;
(* projectionTo3D = IdentityMatrix[4][[1;;3]].RotationMatrix[{{1, 0.000001, 0.0000061, 0.0000021}, {1, 0, 0, 0}}]; *)

projectionMatrix = RotationMatrix[- phi3d, {0, 0, 1}].RotationMatrix[{viewVertical, {0, 0, 1}}].projectionTo3D;

graphElements = {
    {
        FaceForm[Yellow], Map[Sphere[#, thickness * 3]&, Map[projectToDirection[#, projectionMatrix]&, realVertices]]
    }
};

positiveEdges = Select[realEdges, Total[#].projectionVector4D/Norm[Total[#]]/Norm[projectionVector4D] >= - 0.1 &];
negativeEdges = Select[realEdges, Total[#].projectionVector4D/Norm[Total[#]]/Norm[projectionVector4D] < - 0.1 &];

Print[{Length[positiveEdges], Length[negativeEdges]}];

If[Length[realEdges[[1]]] > 2,     
    graphElements = Union[graphElements, 
        {
            {
                Opacity[1], FaceForm[Red], Map[Polygon, Map[projectToDirection[#, projectionMatrix]&, positiveEdges, {2}]]
            }
            ,
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
    ViewVertical -> {0, 0, 1},
    ViewPoint -> {2, -2, 1}*3,
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
