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
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];

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

snap[value_, knownValues_] := Module[
    {epsilon, snapValue, knownIndex, knownValue},
    epsilon = 0.00001;
    For[knownIndex = 1, knownIndex <= Length[knownValues], knownIndex++,
        knownValue = knownValues[[knownIndex]];
        For[offset = -4, offset <= 4, offset ++,
            If[Abs[value - knownValue - offset] < epsilon, Return[knownValue + offset, Module] ];
            If[Abs[value + knownValue + offset] < epsilon, Return[-knownValue - offset, Module] ]
        ];
    ];
    value
];

v362 = getRealVertices[{3, 6, 2}];
(* v263 = getRealVertices[{2, 6, 3}]; *)

v344 = getRealVertices[{3, 4, 4}];
(* v443 = getRealVertices[{4, 4, 3}]; *)


realVertices = v362;

Print["Computing min norm rotation"];
dimension4th = {x1, x2, x3, x4}/.NMinimize[ {maxNorm[{x1, x2, x3, x4}, realVertices], {x1, x2, x3, x4}.{x1, x2, x3, x4} <= 1 }, {x1, x2, x3, x4}][[2]];
rot4th = Transpose[RotationMatrix[{dimension4th, {0, 0, 0, 1}}]];
realVertices3d = Transpose[Transpose[realVertices.rot4th][[1;;3]]];
dimension3rd = {x1, x2, x3}/.NMinimize[ {maxNorm[{x1, x2, x3}, realVertices3d], {x1, x2, x3}.{x1, x2, x3}<=1}, {x1, x2, x3}][[2]];
rot3rd = Transpose[RotationMatrix[{dimension3rd, {0, 0, 1}}]];
rot3rd4D = ArrayFlatten[{{rot3rd, 0},{0, 1}}];
realVertices2d = Transpose[Transpose[realVertices3d.rot3rd][[1;;2]]];
dimension2nd = {x1, x2}/.NMinimize[ {maxNorm[{x1, x2}, realVertices2d], {x1, x2}.{x1, x2} <= 1}, {x1, x2}][[2]];
rot2nd = Transpose[RotationMatrix[{dimension2nd, {0, 1}}]];
rot2nd4D = ArrayFlatten[{{rot2nd, 0}, {0, IdentityMatrix[2]}}];
rot4D = rot4th.rot3rd4D.rot2nd4D * 2;
rotatedRealVertices362 = realVertices.rot4D;
rotatedRealEdges362 = Map[#.rot4D&, realEdges];

knownValues = {0, Sqrt[3]};

Print[rot4D];
Print["362 vertices:"];
(* Print[rotatedRealVertices362]; *)
snappedVertices362 = Map[snap[#, knownValues]&, rotatedRealVertices362, {2}];
Print[snappedVertices362];

rotatedRealVertices344 = v344.rot4D;

Print["344 vertices"];
(* Print[rotatedRealVertices344]; *)
snappedVertices344 = Map[snap[#, knownValues]&, rotatedRealVertices344, {2}];

Print[snappedVertices344];


