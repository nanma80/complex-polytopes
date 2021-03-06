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

symbol = {5, 4, 3};

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

beforePoints = {{-2.480383242146944, 0.5272217335747015, -1.7794269989971931, 0.3782288846496461},
 {-2.8453340453014464, 0.8558249127047565, -0.39329592993311957, -0.8698491358625313},
 {-2.117969759701417, -0.09708252957741059, -1.8043765278867538, -1.4102076950835576},
 {-2.870283574191017, -0.9326116670284419, -0.7557094123786414, -0.24554487271041892}};

(* Validate before points are indeed from realVertices. They are selected from an adhoc script *)
Print[Length[Intersection[realVertices, beforePoints, SameTest -> SameMatrix]] == Length[beforePoints]];

(* beforePoints = Flatten[Join[otherPoints, otherPoints2], 1]; *)
Print[Map[Norm, beforePoints]];
fourBeforePoints = beforePoints[[1;;4]];
Print[Det[fourBeforePoints]];


phi=(Sqrt[5]+1)/2;

theoreticalPoints = {
    {phi, 1, 0, 1/phi},
    {phi, 0, 1/phi, 1},
    {phi, 0, -1/phi, 1},
    {2, 0, 0, 0}
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
    Print[rotatedVertices//Length]; (* 600 *)

    cell600FileName = FileNameJoin[{dataFolder, "polytope_52_5_3.wl"}];

    If[!FileExistsQ[cell600FileName],
        Print["Generating polytope data for " <> cell600FileName];
        cell600Cells = Get["../star-polytope/data/polytope_52_5_3.wl"];
        Print[cell600Cells//Length]; (* 600 *)
        cell600Faces = Union[ Flatten[cell600Cells, 1], SameTest -> sameCenter];
        Print[cell600Faces//Length]; (* 1200 *)
        cell600Edges = Union[ Flatten[Map[getEdgesFromFace, cell600Faces], 1], SameTest -> sameCenter];
        Print[cell600Edges//Length]; (* 720 *)
        cell600Vertices = Union[ Flatten[cell600Faces,1], SameTest -> sameVertex];
        Print[cell600Vertices//Length]; (* 120 *)

        cell600Data = <|
            "cells" -> cell600Cells,
            "faces" -> cell600Faces,
            "edges" -> cell600Edges,
            "vertices" -> cell600Vertices
        |>;

        Save[cell600FileName, cell600Data];
        Print["Saved polytope data to " <> cell600FileName];
    ];

    cell600Data = Get[cell600FileName];
    cell600Edges = cell600Data["edges"];
    cell600Vertices = cell600Data["vertices"];

    edge1 = cell600Edges[[1]];
    Print[edge1];
    Print[edge1[[1]].edge1[[2]]/Norm[edge1[[1]]]^2//N]; (* 0.5 *)
    Print[ArcCos[edge1[[1]].edge1[[2]]/Norm[edge1[[1]]]^2]/Pi*180//N]; (* 60 deg *)

    Print["Intersection of 600-cell vertices and 5{4}3 vertices"];
    (* 120. 3{4}5 vertices contain the 120 vertices of 600-cell *)
    Print[Intersection[N[cell600Vertices], rotatedVertices, SameTest -> SameMatrix]//Length];

    otherVertices = Complement[rotatedVertices, N[cell600Vertices], SameTest -> SameMatrix];
    (* 480 other vertices *)
    Print[otherVertices//Length];

    Print["Breaking edges to 5 parts"];

    selectedEdges = Select[cell600Edges, 
        Length[Intersection[N[getParts[#, 5]], otherVertices, SameTest -> SameMatrix]]>0&
    ];
    Print[selectedEdges//Length]; (* 120 *)
    selectedEdgeEnds = Union[ Flatten[selectedEdges, 1], SameTest -> SameMatrix];
    Print[selectedEdgeEnds//Length]; (* 120 *)
    Print[Intersection[selectedEdgeEnds, N[cell600Vertices], SameTest -> SameMatrix]//Length]; (* 120 *)
    
    selectedBreakingPoints = Flatten[ Map[N[getParts[#, 5]]&, selectedEdges], 1];
    Print[selectedBreakingPoints//Length]; (* 480 *)
    Print[Intersection[otherVertices, selectedBreakingPoints, SameTest -> SameMatrix]//Length]; (* 480 *)
];

(* 

5{4}3 has 600 vertices. 120 of them are from vertices of the 600-cell.
To get the other 480 vertices, do the following.
Consider 20 great circles from the discrete Hopf fibration, which are mapped from the 
20 vertices of the regular dodecahedron. Each of the 20 great circles goes
through 6 600-cell vertices. If it goes through one vertex, it goes through another one
with 60 degrees away. Think of two adjacent 600-cell cells sharing the same face.
The two vertices not on the common face are 60 degrees away.
Such two vertices are connected by {5/2, 5, 3} edges.
In other words, each great circle goes through 6 {5/2, 5, 3} vertices 
(as same as 600-cell vertices) and contains
6 {5/2, 5, 3} edges. Each vertex is used once. There are 120 edges involved.

We break up each of such edges into 5 equal segments, which are delimited by 4 points.
We have 480 breaking points. These are the additional 480 vertices of 5{4}3.

 *)
