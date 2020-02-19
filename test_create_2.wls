#!/usr/bin/env wolframscript


numericalValue = True;

epsilon = 1*^-5;
iterationLimit = 20;

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];

symbol = {3, 6, 2};
(* symbol = {5, 4, 3}; *)

p1 = symbol[[1]];
q = symbol[[2]];
p2 = symbol[[3]];

qDisplayString = getQString[q, "/"];
qFileString = getQString[q, "over"];

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];
Print["-----"];
Print["Shape: " <> shape];

seed = {{1}, {0}};
If[numericalValue, seed = seed * 1.0];

e1 = Exp[Pi I / p1];
e2 = Exp[Pi I / p2];
a12 = - Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])] //FullSimplify;
a21 = a12;

r1 = {{e1^2, 0}, {(e1^2 - 1) a21, 1}}//FullSimplify//ExpToTrig;
r2 = {{1, (e2^2 - 1) a12}, {0, e2^2}}//FullSimplify//ExpToTrig;
Print[r1];

a = {{1, a12}, {a21, 1.}};
ai = Inverse[a];
half = MatrixPower[ai, 1/2];
rot45 =  RotationMatrix[Pi/4];
half = rot45 . half;
Print[half];
Print[half . half];
Print[ai];

seed = half.seed;
r1 = half.r1.Inverse[half]//FullSimplify//ExpToTrig;
r2 = half.r2.Inverse[half]//FullSimplify//ExpToTrig;

edgeGenerators = {r1};

generators = {r1, r2};

edge1 = { seed };

lastElementCount = 0;

For[iteration=1, iteration <= p1 - 1, iteration++,
    AppendTo[edge1, r1.edge1[[Length[edge1]]]];
];


edge1 = edge1//Simplify//ExpToTrig;

Print[" Each edge contains " <> IntegerString[Length[edge1]] <> " vertices."];
If[Length[edge1] != p1 , Print["Error"]; Abort[]];

edges = { edge1 };
lastEdgeCount = 0;

For[iteration=1, iteration <= iterationLimit && lastEdgeCount != Length[edges], iteration++,
    lastEdgeCount = Length[edges];
    For[i=1, i<=Length[generators], i++,
        newElements = Map[(generators[[i]].#)&, edges, {2}];
        edges = Union[edges, newElements, SameTest -> SameTotal]//Simplify//ExpToTrig;
    ];
];

(* edges = Map[half.# &, edges, {2}]; *)

vertices = Union[Flatten[edges, 1], SameTest -> SameMatrix];

Print["Validating..."];

edgeCounts = {};
For[i=1, i<=Length[vertices], i++,
    vertex = vertices[[i]];
    edgeCountContainingVertex = Length[Select[edges, Length[Intersection[#, {vertex}, SameTest -> SameMatrix]] > 0 &]];
    AppendTo[edgeCounts, edgeCountContainingVertex];
];

uniqueEdgeCounts = Union[edgeCounts];
If[Length[uniqueEdgeCounts] == 1, 
        Print[" Every vertex belongs to " <> IntegerString[uniqueEdgeCounts[[1]]] <> " complex edges. "];
        If[uniqueEdgeCounts[[1]] != p2, Abort[]],
    
    Print["Error. The complex polytope is not regular. The edge counts are " <> ToString[edgeCounts]]; Abort[]
];

Print["Vertex count: " <> IntegerString[Length[vertices]] <> " Edge count: " <> IntegerString[Length[edges]] ];

realVertices = Map[getReal, vertices];
realEdges = Map[getReal, edges, {2}];

(* even after rot 45, the generated vertices don't align for 362 *)
Print[realVertices];

(* 
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
rot4D = rot4th.rot3rd4D.rot2nd4D;
rotatedRealVertices = realVertices.rot4D;
rotatedRealEdges = Map[#.rot4D&, realEdges];


dataFolder = "data";
dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

dataObject = <|
    "vertices" -> vertices,
    "edges" -> edges,
    "rotatedRealVertices" -> rotatedRealVertices,
    "rotatedRealEdges" -> rotatedRealEdges
|>;

Print[rotatedRealVertices];

epsilon = 0.00001;
minNonZero = Min[Select[Map[Abs, Flatten[rotatedRealVertices]], # > epsilon&]];
scaledRealVertices = Map[If[Abs[#] < epsilon, 0, # / minNonZero]&, rotatedRealVertices, {2}];
scaledRealEdges = Map[If[Abs[#] < epsilon, 0, # / minNonZero]&, rotatedRealEdges, {3}];

(* Print[scaledRealVertices];

1.22475 = Sqrt[6]/2
3.67423 = 3 * Sqrt[6]/2
2.44949 = Sqrt[6]
 *)

knownValues = {0, 1, Sqrt[6], Sqrt[6]/2, 3 Sqrt[6]/2};

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

snappedVertices = Map[snap[#, knownValues]&, scaledRealVertices, {2}];
vertices = snappedVertices;

snappedEdges = Map[snap[#, knownValues]&, scaledRealEdges, {3}];
edges = snappedEdges;
 *)
(* why are the norms different? *)
(* For[i = 1, i <=Length[vertices], i++,
    vertex = vertices[[i]];
    Print[{i, Norm[vertex]//N, vertex}]
];
 *)
