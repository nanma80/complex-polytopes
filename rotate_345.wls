#!/usr/bin/env wolframscript


numericalValue = True;

epsilon = 1*^-5;
iterationLimit = 20;
dataFolder = "data";
imageFolder = "output";

cubeVertices[dimension_] := 2 * Map[IntegerDigits[#, 2][[2;;dimension+1]]&, Table[k, {k, 2^dimension, 2 * 2^dimension - 1}]] - 1;
allPlusMinus[v_] := Union[Map[(v #)&, cubeVertices[Length[v]]]];
SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
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


(* symbol = {3, 4, 5}; *)
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

vertex1 = realVertices[[1]];
incidentEdges = Select[realEdges, Length[Intersection[{vertex1}, #, SameTest -> SameMatrix]] > 0 &];
Print[incidentEdges//Length];
normVertex = Norm[incidentEdges[[1,1]]];
Print[vertex1];
Print[incidentEdges[[1,1]].incidentEdges[[1,2]]/normVertex/normVertex];

edgeCenters = Map[Total[#]/Norm[Total[#]]&, incidentEdges];
Print[edgeCenters[[1]].edgeCenters[[2]]];
Print[edgeCenters[[1]].edgeCenters[[3]]];
(* Print[edgeCenters[[1]].edgeCenters[[4]]]; *)
(* Print[edgeCenters[[1]].edgeCenters[[5]]]; *)

Print[Norm[edgeCenters[[1]] - edgeCenters[[2]]]];
(* Print[Norm[edgeCenters[[1]] - edgeCenters[[4]]]]; *)
(* Print[(Norm[edgeCenters[[1]] - edgeCenters[[2]]])/(Norm[edgeCenters[[1]] - edgeCenters[[4]]])]; *)

incidentVertices = Union[ Flatten[incidentEdges, 1], edgeCenters, SameTest -> SameMatrix];
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
(* beforePoints = Flatten[Join[otherPoints, otherPoints2], 1];
(* Print[Map[Norm, beforePoints]]; *)
fourBeforePoints = beforePoints[[1;;4]];
Print[Det[fourBeforePoints]];

phi=(Sqrt[5]+1)/2;
face = {
 {phi, 1/phi, 1, 0}/2,
 {phi, -1/phi, 1, 0}/2,
 {1, 0, 0, 0}
};
faceCenter = Mean[face]/Norm[Mean[face]]//FullSimplify
edgeCenterx = Mean[{{phi, 1, 0, 1/phi}/2, {phi, 1, 0, -1/phi}/2}];
edgeCenterx = edgeCenterx / Norm[edgeCenterx] //Simplify;
N[faceCenter.edgeCenterx]
midx = Mean[{edgeCenterx, faceCenter}];
midx = midx/Norm[midx]//FullSimplify;
midx.faceCenter//N

edgeCentery = Mean[{{1, 0, phi, 1/phi}/2, {1, 0, phi, -1/phi}/2}];
edgeCentery = edgeCentery / Norm[edgeCentery] //Simplify;
N[faceCenter.edgeCentery]
midy = Mean[{edgeCentery, faceCenter}];
midy = midy/Norm[midy]//FullSimplify;
midy.faceCenter//N

edgeCenterz = Mean[{{phi, 0, 1/phi, 1}/2, {phi, 0, -1/phi, 1}/2}];
edgeCenterz = edgeCenterz / Norm[edgeCenterz] //Simplify;
N[faceCenter.edgeCenterz]


faces = 
{
    {{0,0,0,1}, {1,0,0,0}, {0,1,0,0}},
    {{0,0,0,1}, {0,-1,0,0}, {0,0,-1,0}}
};

faceCenters = Map[Total, faces];
normFaceCenters = Norm[faceCenters[[1]]];

theoreticalPoints = {
    normFaceCenters faces[[1]][[1]],
    normFaceCenters faces[[1]][[3]],
    normFaceCenters faces[[1]][[2]],
    faceCenters[[2]]
};


theoreticalPoints = theoreticalPoints[[1;;4]];

rot4d = Inverse[fourBeforePoints].theoreticalPoints;

Print["rot4d"];
Print[rot4d];
Print["Is rot4d O(4)?"];
isOrthogonal = SameMatrix[rot4d.Transpose[rot4d], IdentityMatrix[4] * (rot4d.Transpose[rot4d])[[1]][[1]] ];
Print[isOrthogonal];
Print["Det: "];
Print[Det[rot4d]];

If[isOrthogonal && False,

    rotatedVertices = realVertices.rot4d;
    rotatedEdges = Map[#.rot4d&, realEdges];

    (* Print[rotatedVertices]; *)

    knownValues = Union[Flatten[theoreticalPoints]//FullSimplify];

    snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}];
    snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}];

(*     Print[snappedVertices];
    Print[snappedEdges];
 *)
    dataObject["rot4d"] = rot4d;
    dataObject["snappedVertices"] = snappedVertices;
    dataObject["snappedEdges"] = snappedEdges;

    (* If[FileExistsQ[dataFileName], DeleteFile[dataFileName]]; *)
    (* Save[dataFileName, dataObject]; *)
    (* Print["Saved data to " <> dataFileName]; *)

    (* Use the same matrix to rotate 4{4}3 *)
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

    rotatedVertices = realVertices.rot4d*2;
    rotatedEdges = Map[#.rot4d*2&, realEdges];

    knownValues = {0, Sqrt[3], 2 Sqrt[3]};
    snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}];
    snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}];

    (* Print[snappedVertices]; *)
    (* Print[snappedEdges]; *)
    dataObject["rot4d"] = rot4d;
    dataObject["snappedVertices"] = snappedVertices;
    dataObject["snappedEdges"] = snappedEdges;

    (* If[FileExistsQ[dataFileName], DeleteFile[dataFileName]]; *)
    (* Save[dataFileName, dataObject]; *)
    (* Print["Saved data to " <> dataFileName]; *)
];

 *)
