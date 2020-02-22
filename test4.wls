#!/usr/bin/env wolframscript

exportToPov = True;
dataFolder = "data";
imageFolder = "output";
frameFolder = "static_test";
imageSize = {600, 450};

rangeFactor = 0.8;
phi3d = 0;
epsilon = 0.000000001;

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

getEdges[vertices_] := Module[
    {edgeLength, i, j, k},
    edges = {};
    edgeLength = 10^10;
    For[i = 2, i < Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];

    For[i = 1, i <= Length[vertices]-1, i++, 
        For[j = i + 1, j <= Length[vertices], j++, 
            If[Norm[vertices[[i]] - vertices[[j]]] == edgeLength,
                AppendTo[edges, {i, j}];
            ];
        ];
    ];
    edges
];

getRealVertices[symbol_] := Module[
    {shape, shapeFile, dataFileName, dataObject, complexVertices},
    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];
    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];
    Print["Reading data for " <> shape <> " from " <> dataFileName];
    dataObject = Get[dataFileName];
    complexVertices = dataObject[["vertices"]];
    Map[getReal, complexVertices]
];

v362 = getRealVertices[{3, 6, 2}];
v263 = getRealVertices[{2, 6, 3}];

v344 = getRealVertices[{3, 4, 4}];
v443 = getRealVertices[{4, 4, 3}];
Print[Map[Length, {v362, v263, v344, v443}]];
(* {24, 16, 72, 96} *)

Print[Length[Intersection[v263, v362, SameTest -> SameMatrix]]];
(* 4 *)

Print[Length[Intersection[v344, v443, SameTest -> SameMatrix]]];
(* 24 *)


Print[Length[Intersection[v362, v344, SameTest -> SameMatrix]]];
(* all 24 vertices in v362 are in v344 *)

Print[Length[Intersection[v263, v443, SameTest -> SameMatrix]]];
(* all 16 vertices in v263 are in v433 *)

Print[Length[Intersection[v362, v443, SameTest -> SameMatrix]]];
(* 8 *)

Print[Length[Intersection[v263, v344, SameTest -> SameMatrix]]];
(* 4: 4 vertices of 263 are in 362. all 362 are in 344 *)

