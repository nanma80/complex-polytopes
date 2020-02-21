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
    Null
];

nVector[r1_, p1_] := Module[{n1Matrix, n11, n12, epsilon}, 
    epsilon = 0.000001;
    n1Matrix = (r1 - IdentityMatrix[2])/(Exp[2 Pi I / p1] - 1);
    n11 = Sqrt[Re[n1Matrix[[1]][[1]]]];
    n12 = n1Matrix[[1]][[2]]/n11;
    If[Abs[Im[n12]] < epsilon, n12 = Re[n12]];
    {n11, n12}
];


symbol = {3, 6, 2};

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

(* Print[complexVertices]; *)

realVertices = Map[getReal, complexVertices];
realEdges = Map[getReal, complexEdges, {2}];

vertex1 = realVertices[[1]];
incidentEdges = Select[realEdges, Length[Intersection[{vertex1}, #, SameTest -> SameMatrix]] > 0 &];
otherPoints = Map[Complement[#, {vertex1}, SameTest -> SameMatrix]&, incidentEdges];
beforePoints = Flatten[Join[{{vertex1}}, otherPoints], 1];
(* Print[Map[Norm, beforePoints]]; *)
fourBeforePoints = beforePoints[[1;;4]];



theoreticalPoints = {
    {1, 1, 0, 1 + Sqrt[3]},
    {1 + Sqrt[3], 1, 0, 1},
    {1, 1 + Sqrt[3], 0, 1},
    {0, -1, -1, 1 + Sqrt[3]}
};

(* Print[Map[Norm, theoreticalPoints]]; *)

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

    knownValues = {0, 1, 1 + Sqrt[3]};

    snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}];
    snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}];

    dataObject["rot4d"] = rot4d;
    dataObject["snappedVertices"] = snappedVertices;
    dataObject["snappedEdges"] = snappedEdges;
(*     dataObject["rotatedRealVertices"] = snappedVertices;
    dataObject["rotatedRealEdges"] = snappedEdges; *)

    If[FileExistsQ[dataFileName], DeleteFile[dataFileName]];
    Save[dataFileName, dataObject];
    Print["Saved data to " <> dataFileName];
];

