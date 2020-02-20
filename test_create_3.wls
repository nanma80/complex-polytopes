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

Print[realVertices[[22]]];
Print["two edges"];
Print[realEdges[[13]]//Total];
Print[realEdges[[16]]//Total];

Print[];
Print["seed"];
Print[seed];
Print[getReal[seed]];

cosHalfSigma = Sqrt[(Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])] + 1)/2];
halfSigma = ArcCos[cosHalfSigma];

theta1 = -Pi/4 + halfSigma;
theta2 = -Pi/4 - halfSigma;
n1Precise = {Cos[theta1], Sin[theta1]};
n2Precise = {Cos[theta1], Sin[theta1]};

rot2d = RotationMatrix[Pi/2+theta1+Pi];
rot4d = IdentityMatrix[4];
rot4d[[1]][[1]] = rot2d[[1]][[1]];
rot4d[[1]][[3]] = rot2d[[1]][[2]];
rot4d[[3]][[1]] = rot2d[[2]][[1]];
rot4d[[3]][[3]] = rot2d[[2]][[2]];

Print[rot4d//N];
Print["seed"];
Print[getReal[seed].rot4d];
rotatedVertices = realVertices.rot4d;
rotatedEdges = Map[#.rot4d&, realEdges];

Print[];
Print[rotatedEdges[[13]]//Total];
Print[rotatedEdges[[16]]//Total];

rot2d2 = RotationMatrix[3 Pi/4];
rot4d2 = IdentityMatrix[4];
rot4d2[[2]][[2]] = rot2d2[[1]][[1]];
rot4d2[[2]][[3]] = rot2d2[[1]][[2]];
rot4d2[[3]][[2]] = rot2d2[[2]][[1]];
rot4d2[[3]][[3]] = rot2d2[[2]][[2]];

rot4d3 = ArrayFlatten[{{1, 0}, {0, RotationMatrix[1.501885558340156, {1, -1, 0}]}}];
Print[rot4d3];

rotatedVertices = rotatedVertices.rot4d2.rot4d3;
rotatedEdges = Map[#.rot4d2.rot4d3&, rotatedEdges];

faceCenter13 = rotatedEdges[[13]]//Total;
faceCenter16 = rotatedEdges[[16]]//Total;
Print[faceCenter13/Abs[faceCenter13[[1]]]];
Print[faceCenter16/Abs[faceCenter16[[1]]]];

Print["rotated vertices"];
Print[rotatedVertices[[22]]/Abs[rotatedVertices[[22]][[2]]]];
Print[rotatedVertices[[2]]/Abs[rotatedVertices[[22]][[2]]]];
Print[rotatedVertices[[1]]/Abs[rotatedVertices[[22]][[2]]]];

normFactor = Abs[rotatedVertices[[22]][[2]]];
rotatedVertices = rotatedVertices/normFactor;
rotatedEdges = rotatedEdges/normFactor;

rotatedVertices//MatrixForm
Map[Total, rotatedEdges]//MatrixForm


knownValues = {0, 1, 1 + Sqrt[3]};

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

snappedVertices = Map[snap[#, knownValues]&, rotatedVertices, {2}];

snappedEdges = Map[snap[#, knownValues]&, rotatedEdges, {3}];

Print[snappedVertices];
Print[snappedEdges];





