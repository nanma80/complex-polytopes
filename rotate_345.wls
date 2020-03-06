#!/usr/bin/env wolframscript


numericalValue = True;

epsilon = 1*^-5;
iterationLimit = 20;
dataFolder = "data";
imageFolder = "output";

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


symbol = {3, 4, 5};
(* symbol = {5, 4, 3}; *)

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

(* vertex1 = realVertices[[1]];
incidentEdges = Select[realEdges, Length[Intersection[{vertex1}, #, SameTest -> SameMatrix]] > 0 &];
Print[incidentEdges//Length];
normVertex = Norm[incidentEdges[[1,1]]];
Print[vertex1];
Print[incidentEdges[[1,1]].incidentEdges[[1,2]]/normVertex/normVertex];
 *)
(* edgeCenters = Map[Total[#]/Norm[Total[#]]&, incidentEdges]; *)
(* Print[edgeCenters[[1]].edgeCenters[[2]]]; *)
(* Print[edgeCenters[[1]].edgeCenters[[3]]]; *)
(* Print[edgeCenters[[1]].edgeCenters[[4]]]; *)
(* Print[edgeCenters[[1]].edgeCenters[[5]]]; *)

(* Print[Norm[edgeCenters[[1]] - edgeCenters[[2]]]]; *)
(* Print[Norm[edgeCenters[[1]] - edgeCenters[[4]]]]; *)
(* Print[(Norm[edgeCenters[[1]] - edgeCenters[[2]]])/(Norm[edgeCenters[[1]] - edgeCenters[[4]]])]; *)

(* incidentVertices = Union[ Flatten[incidentEdges, 1], edgeCenters, SameTest -> SameMatrix];
incidentVertices = Map[#/Norm[#]&, incidentVertices];
innerProducts = {};
For[i = 1, i<=Length[incidentVertices], i++,
    For[j = i+1, j<=Length[incidentVertices], j++,
        innerProduct = incidentVertices[[i]].incidentVertices[[j]];
        If[Abs[innerProduct - 0.8090169943749466] < 0.00001,
            Print[{i, j, innerProduct}];
        ];
        AppendTo[innerProducts, innerProduct];
    ];
];
distinctInnerProducts = Union[innerProducts, SameTest -> (Abs[#1-#2] < epsilon&)];
Print[distinctInnerProducts];
 *)

(* {0.45529649865501276, 0.4999999999999978, 0.5228511020787892, 0.6338497452485641, 0.7328667969030407, 0.7366852097826335, 0.766360424875417, 0.8090169943749466, 0.8142632253284559, 0.8459908542188238, 0.9265733799181644, 0.9290548650362505, 0.9472735804116371, 0.9781476007338055} *)

(* hit: *)
(* {0.45529649865501276, 0.4999999999999978, 0.7366852097826335, 0.8090169943749466} *)
(* 0.809: incidentEdges[[1,3]].incidentEdges[[2,3]]/Norm[incidentEdges[[1,1]]]^2 *)


(* 
0.9781476007338055 == Cos[Pi/15] == Cos[12 deg], 600-cell edge angle/3
0.8090169943749458 == Cos[Pi/5] == Cos[36 deg], 600-cell edge length
0.5 == Cos[Pi/3] == Cos[60 deg], 600-cell distant-2 vertex neighbors
*)

(* hit from 5{4}3 *)
(* {0.4999999999999972, 0.5490927356975517, 0.8090169943749458, 0.8884507093343049} *)

(* vertex1 = realVertices[[1]];
incidentEdges = Select[realEdges, Length[Intersection[{vertex1}, #, SameTest -> SameMatrix]] > 0 &];
otherPoints = Map[Complement[#, {vertex1}, SameTest -> SameMatrix]&, incidentEdges];
vertex2 = otherPoints[[1]][[1]];
incidentEdges2 = Select[realEdges, Length[Intersection[{vertex2}, #, SameTest -> SameMatrix]] > 0 &];
otherPoints2 = Map[Complement[#, {vertex1, vertex2}, SameTest -> SameMatrix]&, incidentEdges2];
 *)

(* edge1 = realEdges[[1]];
normalEdge1 = Total[edge1]/Norm[Total[edge1]];
Print[edge1];

greatestInnerProd = -1;
For[edgeIndex = 2, edgeIndex <= Length[realEdges], edgeIndex++,
(* For[edgeIndex = 2, edgeIndex <= 3, edgeIndex++, *)
    otherEdge = realEdges[[edgeIndex]];
    normalOtherEdge = Total[otherEdge]/Norm[Total[otherEdge]];
    innerProd = normalOtherEdge.normalEdge1;
    If[innerProd > greatestInnerProd,
        greatestInnerProd = innerProd
    ];
];

Print[greatestInnerProd];
 *)
beforePoints = {{-2.313764388333717, 2.083322812807989, -0.1592858275051926, 0.14342160328500508},
 {-2.3441073217849473, 1.1609761130396368, -1.2618331601939548, -1.1422581682618216},
 {-2.47585118264818, 1.1748229507866157, 0.6518603455072836, -1.3433954607114416},
 {-2.578827297471305, -0.4385823080235634, -0.34944196504784125, -1.6657931925030236}};

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
    {phi, -1, 0, 1/phi}
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

    cell600cells = Get["../star-polytope/data/polytope_3_3_5_cell600.wl"];

    cell600Faces = Flatten[cell600cells, 1];
    cell600Edges = Union[ Flatten[Map[getEdgesFromFace, cell600Faces], 1], SameTest -> sameCenter];
    cell600Vertices = Union[ Flatten[cell600Faces,1], SameTest -> sameVertex];
    Print[cell600Vertices//Length]; (* 120 *)
    Print[rotatedVertices//Length]; (* 360 *)
    Print[cell600Edges//Length]; (* 720 *)
    Print[cell600Faces//Length]; (* 2400 because we didn't dedup *)

    (* 120. 3{4}5 vertices contain the 120 vertices of 600-cell *)
    Print[Intersection[N[cell600Vertices], rotatedVertices, SameTest -> SameMatrix]//Length];

    otherVertices = Complement[rotatedVertices, N[cell600Vertices], SameTest -> SameMatrix];
    Print[otherVertices//Length];

    getThirds[edge1_] := {
        Sin[2 Pi/15] edge1[[1]] + Sin[Pi/15] edge1[[2]],
        Sin[Pi/15] edge1[[1]] + Sin[2 Pi/15] edge1[[2]]
    }/Sin[4 Pi/5];

    edgeThirds = Map[getThirds, cell600Edges];
    selectedEdgeThirds = Select[edgeThirds, Length[Intersection[#, otherVertices, SameTest -> SameMatrix]]>0&];
    Print[selectedEdgeThirds//Length]; (* 120 *)

    selectedVertices = Flatten[selectedEdgeThirds, 1];
    Print[selectedVertices//Length]; (* 240 *)
    (* 240. All the other vertices match the thirds points *)
    Print[Intersection[N[selectedVertices], otherVertices, SameTest -> SameMatrix]//Length];

    (* Print[rotatedVertices]; *)
    (* Print[Norm/@rotatedVertices]; *)

(*     knownValues = Union[Flatten[theoreticalPoints]//FullSimplify];
    Print[knownValues//N];
 *)
    (* snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}]; *)
    (* snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}]; *)

    (* Print[snappedVertices[[1;;20]]]; *)
    (* Print[snappedEdges[[1;;5]]]; *)

    (* Print[snappedVertices]; *)
    (* Print[snappedEdges]; *)

    (* dataObject["rot4d"] = rot4d; *)
    (* dataObject["snappedVertices"] = snappedVertices; *)
    (* dataObject["snappedEdges"] = snappedEdges; *)

    (* If[FileExistsQ[dataFileName], DeleteFile[dataFileName]]; *)
    (* Save[dataFileName, dataObject]; *)
    (* Print["Saved data to " <> dataFileName]; *)

];


