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
altMode = False;

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

getEdges[vertices_] := Module[
    {edgeLength, i, j},
    edges = {};
    edgeLength = 10^10;
    For[i = 2, i < Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];

    For[i = 1, i <= Length[vertices]-1, i++, 
        For[j = i + 1, j <= Length[vertices], j++, 
            If[ Abs[Norm[vertices[[i]] - vertices[[j]]] - edgeLength] < epsilon, AppendTo[edges, {i, j}] ];   
        ];
    ];
    edges
];


symbol = {4, 4, 3};

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
half9 = Select[Table[k, {k, 1, 72}], Abs[realVertices[[#]].realVertices[[9]]/nv^2 - 0.5] < epsilon&]
Intersection[half1, half9]
realVertices[[41]].realVertices[[40]]/nv^2
 *)
beforePoints = {realVertices[[1]], realVertices[[9]], realVertices[[17]], realVertices[[14]]};

(* Validate before points are indeed from realVertices. They are selected from an adhoc script *)
Print[Length[Intersection[realVertices, beforePoints, SameTest -> SameMatrix]] == Length[beforePoints]];

(* beforePoints = Flatten[Join[otherPoints, otherPoints2], 1]; *)
Print[Map[Norm, beforePoints]];
fourBeforePoints = beforePoints[[1;;4]];
Print[Det[fourBeforePoints]];

theoreticalPoints = 
If[altMode,
    (* vertex first projectin of 24-cell *)
    {
        {2, 0, 0, 0},
        {1, 1, 1, 1},
        {1, 1, 1, -1},
        {1, 1, -1, 1}
    } Sqrt[3],
    (* cell first projectin of 24-cell *)
    theoreticalPoints = {
        {1, 1, 0, 0},
        {1, 0, 1, 0},
        {1, 0, 0, 1},
        {1, 0, 0, -1}
    } 2 Sqrt[3]
];

rot4d = Inverse[fourBeforePoints].theoreticalPoints;

Print["rot4d"];
Print[rot4d];
Print["Is rot4d O(4)?"];
isOrthogonal = SameMatrix[rot4d.Transpose[rot4d], IdentityMatrix[4] * (rot4d.Transpose[rot4d])[[1]][[1]] ];
Print[isOrthogonal];
Print["Det: "];
Print[Det[rot4d]];


If[isOrthogonal,
    (* rotated and snapped in another script *)
    (* rotatedVertices = dataObject[["snappedVertices"]]/Sqrt[3]; *)
    (* rotatedEdges = dataObject[["snappedVertices"]]/Sqrt[3]; *)

    rotatedVertices = realVertices.rot4d;
    rotatedEdges = Map[#.rot4d&, realEdges];
    Print[rotatedVertices//Length]; (* 96 *)
    (* Print[rotatedVertices]; (* 96 *) *)

    knownValues = Union[Flatten[theoreticalPoints]//FullSimplify, {Sqrt[3]}];
    (* Print[knownValues]; *)
    snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}];
    snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}];

    (* Print[snappedVertices]; *)
    (* Print[snappedEdges]; *)
    rotatedVertices = snappedVertices;
    rotatedEdges = snappedEdges;
    Print[rotatedVertices[[1;;10]]];

    polytopeDataFileName = If[altMode, "polytope_3_4_3_alt.wl", "polytope_3_4_3.wl"];
    polytopeFileName = FileNameJoin[{dataFolder, polytopeDataFileName}];

    If[!FileExistsQ[polytopeFileName],
        Print["Generating polytope data for " <> polytopeFileName];
        polytopeCells = Get["../star-polytope/data/" <> polytopeDataFileName];
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

    factor = If[altMode, Sqrt[3], Sqrt[3] * 2];
    polytopeData = Get[polytopeFileName];
    polytopeEdges = polytopeData["edges"] * factor //Simplify;
    polytopeVertices = polytopeData["vertices"] * factor //Simplify;
    polytopeFaces = polytopeData["faces"] * factor //Simplify;
    polytopeCells = polytopeData["cells"] * factor //Simplify;

    edge1 = polytopeEdges[[1]];
    Print[edge1];
    Print[edge1[[1]].edge1[[2]]/Norm[edge1[[1]]]^2//N]; (* 0.5 *)
    Print[ArcCos[edge1[[1]].edge1[[2]]/Norm[edge1[[1]]]^2]/Pi*180//N]; (* 60 deg *)

    Print["Intersection of 24-cell vertices and 4{4}3 vertices"];
    (* 24 *)
    Print[Intersection[N[polytopeVertices], rotatedVertices, SameTest -> SameMatrix]//Length];

    otherVertices = Complement[rotatedVertices, N[polytopeVertices], SameTest -> SameMatrix];
    (* 72 other vertices *)
    Print[otherVertices//Length];

    targetNorm = snappedVertices[[1]]//Norm//Simplify;
    Print["targetNorm" <> ToString[InputForm[targetNorm]]];

    polytopeVertices = polytopeVertices / Norm[polytopeVertices[[1]]] * targetNorm//Simplify;
    edgeCenters = Map[Total, polytopeEdges];
    edgeCenters = edgeCenters / Norm[edgeCenters[[1]]] * targetNorm//Simplify;

    (* Print["edge centers"]; *)
    (* Print[edgeCenters]; *)
    (* alt: {3, 1, 1, 1}, normalized, plus minus, permutate *)
    (* alt: {0, 2, 2, 2}, normalized, plus minus, permutate *)
    (* original: {4, 2, 2, 0} *)

    faceCenters = Map[Total, polytopeFaces];
    faceCenters = faceCenters / Norm[faceCenters[[1]]] * targetNorm//Simplify;
    (* Print["face centers"]; *)
    (* Print[faceCenters]; *)
    (* alt: {2, 1, 1, 0}, normalized, plus minus, permutate *)
    (* original: {3, 1, 1, 1} * Sqrt[2], {0, 2, 2, 2} * Sqrt[2] *)

    Print[Intersection[N[polytopeVertices], snappedVertices, SameTest -> SameMatrix]//Length];


    nearestNeighborEdges = {};

    edgeIndices = getEdges[snappedVertices];
    Print["Number of nearest neighbor edges: " <> IntegerString[Length[edgeIndices]]];
    edges = Map[snappedVertices[[#]]&, edgeIndices, {2}];
    verticesInEdges = Union[Flatten[edges, 1]];

    Print[verticesInEdges//Length]; (* 96 *)
    Print[snappedVertices//Length]; (* 96 *)
    Print[edgeIndices//Length]; (* 96 *)

    components = ConnectedComponents[Graph[edgeIndices]];
    Print[components//Length]; (* 8 *)
    Print[Length/@components]; (* 12 *)

    Print["vertices by great cicles"];
    verticesInComps = {};
    For[compIndex = 1, compIndex <= Length[components], compIndex++,
      component = components[[compIndex]];
      verticesInComp = Map[snappedVertices[[#]]&, component];

      Print[Intersection[N[polytopeVertices], verticesInComp, SameTest -> SameMatrix]//Length];
      Print[verticesInComp];

      AppendTo[verticesInComps, verticesInComp];
    ];

(*     Print["Breaking edges to 5 parts"];

    selectedEdges = Select[polytopeEdges, 
        Length[Intersection[N[getParts[#, 5]], otherVertices, SameTest -> SameMatrix]]>0&
    ];
    Print[selectedEdges//Length]; (* 120 *)
    selectedEdgeEnds = Union[ Flatten[selectedEdges, 1], SameTest -> SameMatrix];
    Print[selectedEdgeEnds//Length]; (* 120 *)
    Print[Intersection[selectedEdgeEnds, N[polytopeVertices], SameTest -> SameMatrix]//Length]; (* 120 *)
    
    selectedBreakingPoints = Flatten[ Map[N[getParts[#, 5]]&, selectedEdges], 1];
    Print[selectedBreakingPoints//Length]; (* 480 *)
    Print[Intersection[otherVertices, selectedBreakingPoints, SameTest -> SameMatrix]//Length]; (* 480 *)
 *)
 ];


(*

4{4}3 has 96 vertices. 24 of them are from vertices of the 24-cell.
To get the other 72 vertices, do the following.
Consider 8 great circles from the discrete Hopf fibration, which are mapped from the 
8 vertices of the cube. Each of the 8 great circles goes 
through 3 24-cell vertices.

??? The following needs update. Still trying to figure out.

If it goes through one vertex, it goes through another one
with 120 degrees away. 

We break up each cell diagonal into 4 equal segments, which are delimited by 3 points.
We have 72 breaking points. These are the additional 72 vertices of 4{4}3.

*)
