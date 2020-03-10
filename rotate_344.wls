#!/usr/bin/env wolframscript


numericalValue = True;

exportToPov = True;
imageSize = {600, 450};
perspective = True;

(* rangeFactor = 0.8; *)
rangeFactor = 0.6;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

epsilon = 1*^-5;
iterationLimit = 20;
dataFolder = "data";
imageFolder = "output";

perspectiveProjection[point_, fullProjectionMatrix_, wDistance_ ] := projectToDirection[point, fullProjectionMatrix[[1;;3]]] / (1 + point.(fullProjectionMatrix[[4]])/wDistance);
projectToDirection[vertex4d_, projectionMatrix_] := projectionMatrix.vertex4d;
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameVertex[point1_, point2_] := point1 == point2;
cubeVertices[dimension_] := 2 * Map[IntegerDigits[#, 2][[2;;dimension+1]]&, Table[k, {k, 2^dimension, 2 * 2^dimension - 1}]] - 1;
allPlusMinus[v_] := Union[Map[(v #)&, cubeVertices[Length[v]]]];
SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
sameCenter[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];
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

nVector[r1_, p1_] := Module[{n1Matrix, n11, n12, epsilon}, 
    epsilon = 0.000001;
    n1Matrix = (r1 - IdentityMatrix[2])/(Exp[2 Pi I / p1] - 1);
    n11 = Sqrt[Re[n1Matrix[[1]][[1]]]];
    n12 = n1Matrix[[1]][[2]]/n11;
    If[Abs[Im[n12]] < epsilon, n12 = Re[n12]];
    {n11, n12}
];

getParts[edge1_, numParts_] := Module[
    {alpha, betaStep},
    alpha = ArcCos[edge1[[1]].edge1[[2]]/Norm[edge1[[1]]]^2];
    betaStep = alpha/numParts;
    Table[(Sin[alpha - k * betaStep] edge1[[1]] + Sin[k * betaStep] edge1[[2]])/Sin[alpha], {k, 1, numParts - 1}]
];

symbol = {3, 4, 4};

p1 = symbol[[1]];
q = symbol[[2]];
p2 = symbol[[3]];

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];

dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

dataObject = Get[dataFileName];

complexVertices = dataObject[["vertices"]];
complexEdges = dataObject[["edges"]];

r1 = dataObject[["r1"]];
r2 = dataObject[["r2"]];
seed = dataObject[["seed"]];

realVertices = Map[getReal, complexVertices];
realEdges = Map[getReal, complexEdges, {2}];

(* 
half1 = Select[Table[k, {k, 1, 72}], Abs[realVertices[[#]].realVertices[[1]]/nv^2 - 0.5] < epsilon&]
half7 = Select[Table[k, {k, 1, 72}], Abs[realVertices[[#]].realVertices[[7]]/nv^2 - 0.5] < epsilon&]
Intersection[half1, half7]
realVertices[[8]].realVertices[[10]]/nv^2
*)
beforePoints = {realVertices[[1]], realVertices[[7]], realVertices[[8]], realVertices[[10]]};

(* Validate before points are indeed from realVertices. They are selected from an adhoc script *)
Print[Length[Intersection[realVertices, beforePoints, SameTest -> SameMatrix]] == Length[beforePoints]];

(* beforePoints = Flatten[Join[otherPoints, otherPoints2], 1]; *)
Print[Map[Norm, beforePoints]];
fourBeforePoints = beforePoints[[1;;4]];
Print[Det[fourBeforePoints]];

theoreticalPoints = {
    {2, 0, 0, 0},
    {1, 1, 1, 1},
    {1, 1, 1, -1},
    {1, 1, -1, 1}
};


rot4d = Inverse[fourBeforePoints].theoreticalPoints;

Print["rot4d"];
Print[rot4d];
Print["Is rot4d O(4)?"];
isOrthogonal = SameMatrix[rot4d.Transpose[rot4d], IdentityMatrix[4] * (rot4d.Transpose[rot4d])[[1]][[1]] ];
Print[isOrthogonal];
Print["Det: "];
Print[Det[rot4d]];



If[isOrthogonal,

    rotatedVertices = realVertices.rot4d;
    rotatedEdges = Map[#.rot4d&, realEdges];
    Print[rotatedVertices//Length]; (* 72 *)

    polytopeFileName = FileNameJoin[{dataFolder, "polytope_3_4_3_alt.wl"}];

    If[!FileExistsQ[polytopeFileName],
        Print["Generating polytope data for " <> polytopeFileName];
        polytopeCells = Get["../star-polytope/data/polytope_3_4_3_alt.wl"];
        Print[polytopeCells//Length]; (* 24 *)
        polytopeFaces = Union[ Flatten[polytopeCells, 1], SameTest -> sameCenter];
        Print[polytopeFaces//Length]; (* 96 *)
        polytopeEdges = Union[ Flatten[Map[getEdgesFromFace, polytopeFaces], 1], SameTest -> sameCenter];
        Print[polytopeEdges//Length]; (* 96 *)
        polytopeVertices = Union[ Flatten[polytopeFaces,1], SameTest -> sameVertex];
        Print[polytopeVertices//Length]; (* 24 *)

        polytopeData = <|
            "cells" -> polytopeCells,
            "faces" -> polytopeFaces,
            "edges" -> polytopeEdges,
            "vertices" -> polytopeVertices
        |>;

        Save[polytopeFileName, polytopeData];
        Print["Saved polytope data to " <> polytopeFileName];
    ];

    polytopeData = Get[polytopeFileName];
    polytopeEdges = polytopeData["edges"];
    polytopeVertices = polytopeData["vertices"];
    polytopeCells = polytopeData["cells"];

    Print["Intersection of 24-cell vertices and 3{4}4 vertices"];
    (* 24 *)
    Print[Intersection[N[polytopeVertices], rotatedVertices, SameTest -> SameMatrix]//Length];

    otherVertices = Complement[rotatedVertices, N[polytopeVertices], SameTest -> SameMatrix];
    (* 48 other vertices *)
    Print[otherVertices//Length];

    diagonals = {};
    For[vIndex1 = 1, vIndex1 <= Length[polytopeVertices] - 1, vIndex1 ++,
        For[vIndex2 = vIndex1 + 1, vIndex2 <= Length[polytopeVertices], vIndex2 ++,
            If[polytopeVertices[[vIndex1]].polytopeVertices[[vIndex2]] == 0,
                AppendTo[diagonals, {polytopeVertices[[vIndex1]], polytopeVertices[[vIndex2]]}];
            ];
        ];
    ];
    Print[diagonals//Length];

    Print["Breaking edges to 3 parts"];

    selectedEdges = Select[diagonals, 
        Length[Intersection[N[getParts[#, 3]], otherVertices, SameTest -> SameMatrix]]>0&
    ];
    Print[selectedEdges//Length]; (* 24 *)
    selectedEdgeEnds = Union[ Flatten[diagonals, 1], SameTest -> SameMatrix];
    Print[selectedEdgeEnds//Length]; (* 24 *)
    Print[Intersection[selectedEdgeEnds, N[polytopeVertices], SameTest -> SameMatrix]//Length]; (* 24 *)
    
    selectedBreakingPoints = Flatten[ Map[N[getParts[#, 3]]&, selectedEdges], 1];
    Print[selectedBreakingPoints//Length]; (* 48 *)
    Print[Intersection[otherVertices, selectedBreakingPoints, SameTest -> SameMatrix]//Length]; (* 48 *)

    cellCenters = Map[Mean[Mean/@#]&, polytopeCells];
    closestCenterInnerProd = Max[Map[#.selectedBreakingPoints[[1]]/Norm[cellCenters[[1]]]/Norm[selectedBreakingPoints[[1]]]&, cellCenters]];
    closestCenters = {};
    For[pointIndex = 1, pointIndex<=Length[selectedBreakingPoints], pointIndex++,
        point = selectedBreakingPoints[[pointIndex]];
        centers = Select[cellCenters, point.#/Norm[#]/Norm[point] > closestCenterInnerProd - epsilon&];
        If[Length[centers] != 1, Print["The closest center to a point is not unique"]];
        AppendTo[closestCenters, centers[[1]]];
    ];
    Print[Length[Union[closestCenters]]]; (* 24. All cell centers have closest breaking points *)
    Print[Map[#[[2]]&, Tally[closestCenters]]//Union] (* {2}: each cell center is close to two breaking points *)
];

(*

3{4}4 has 72 vertices. 24 of them are from vertices of the 24-cell.
To get the other 48 vertices, do the following.
Consider 6 great circles from the discrete Hopf fibration, which are mapped from the 
6 vertices of the regular octahedron. Each of the 6 great circles goes 
through 4 24-cell vertices.

If it goes through one vertex, it goes through another one
with 90 degrees away. If we take an octahedral cell from the 24-cell, opposite vertices
of the octahedron are 90 degrees away. If we connect them we have a cell-diagonal.
Each great circle goes through 4 24-cell vertices and 4 cell diagonals. In total,
we talk about 24 cell diagonals, exactly one diagonal from each cell.

We break up each cell diagonal into 3 equal segments, which are delimited by 2 points.
We have 48 breaking points. These are the additional 48 vertices of 3{4}4.

*)
