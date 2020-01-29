#!/usr/bin/env wolframscript

symbols = {
(*     {3, 3, 3}
    ,{3, 5, 3}
    ,{4, 4, 2}
    ,{3, 4, 3}
    ,{5, 4, 2}
    ,{2, 4, 5}
    ,{3, 6, 2}
    , {3, 3, 2}
    , {3, 5/2, 3}
    , {5, 3, 2}
    ,{5, 6, 2}
    ,{5, 4, 3}
 *)    {5, 3, 5}
};

(* symbol = {5, 6, 2}; *)

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

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];

    p1 = symbol[[1]];
    q = symbol[[2]];
    p2 = symbol[[3]];

    qDisplayString = getQString[q, "/"];
    qFileString = getQString[q, "over"];

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];
    Print["-----"];
    Print["Shape: " <> shape];

    (* 
    In this script, we assume the first node is active (circled) and second node is inactive (not circled)
    This implies the second component is seed is zero because of the structure of r1, r2.
    *)
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

    (* why are the norms different? *)
    (* For[i = 1, i <=Length[vertices], i++,
        vertex = vertices[[i]];
        Print[{i, Norm[vertex]//N, vertex}]
    ];
     *)

    If[FileExistsQ[dataFileName], DeleteFile[dataFileName]];
    Save[dataFileName, dataObject];
    Print["Saved cells to " <> dataFileName];
];
