#!/usr/bin/env wolframscript

symbols = {
    {3, 4, 2}
    , {2, 4, 3}
    , {4, 4, 2}
    , {2, 4, 4}
    , {5, 4, 2}
    , {2, 4, 5}
    , {6, 4, 2}
    , {2, 4, 6}

    , {3, 3, 3}

    , {3, 6, 2}
    , {2, 6, 3}

    , {3, 4, 3}
    , {4, 3, 4}

    , {3, 8, 2}
    , {2, 8, 3}

    , {4, 6, 2}
    , {2, 6, 4}

    , {4, 4, 3}
    , {3, 4, 4}

    , {3, 5, 3}

    , {5, 3, 5}

    , {3, 10, 2}
    , {2, 10, 3}

    , {5, 6, 2}
    , {2, 6, 5}

    , {5, 4, 3}
    , {3, 4, 5}
    
    (* starry *)
    , {3, 3, 2}
    , {3, 5/2, 3}
    , {5, 5/2, 5}
    , {5, 3, 2}
};

symbols = { {3, 8, 2} };

epsilon = 0.00001;

dataFolder = "data";
imageFolder = "output";
scaling = False;

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameVertex[v1_, v2_] := ( v1 == v2 ) || (Norm[v1 - v2] < epsilon);
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];

decomposeUnitary[r1_] := Module[{eiphiby2, phi, r1Right, theta, eiphi1, eiphi2, phi1, phi2, psi, delta, approximateR1}, 
    eiphiby2 = Sqrt[Det[r1]];
    phi = Im[Log[Det[r1]]];
    r1Right = r1 / eiphiby2;

    theta = ArcCos[Abs[r1Right[[1]][[1]]]];
    eiphi1 = r1Right[[1]][[1]]/Cos[theta];
    eiphi2 = r1Right[[1]][[2]]/Sin[theta];
    phi1 = Im[Log[eiphi1]];
    phi2 = Im[Log[eiphi2]];
    psi = (phi1 + phi2)/2;
    delta = (phi1 - phi2)/2;

    (* Print["phi, theta, psi, delta, phi1, phi2"]; *)
    (* Print[{phi, theta, psi, delta, phi1, phi2}/Pi]; *)

    approximateR1 = Exp[I phi/2] {{Exp[I psi], 0}, {0, Exp[-I psi]}} . {{Cos[theta], Sin[theta]}, {-Sin[theta], Cos[theta]}} . {{Exp[I delta], 0}, {0, Exp[-I delta]}};

    {phi, theta, psi, delta, phi1, phi2}
];

dataFolder = "data";

idMatrix = IdentityMatrix[2];

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];

    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

    dataObject = Get[dataFileName];

    vertexFileName = FileNameJoin[{dataFolder, "vertices", shapeFile <> If[scaling, "_scaled", ""] <> "_vertices.txt"}];

    realVertices = dataObject[["rotatedRealVertices"]];

    r1 = dataObject[["r1"]];
    r2 = dataObject[["r2"]];

    Print[shape];
    Print["r1, r2"]
    Print[r1];
    Print[r2];
(*     Print[SameMatrix[r1.ConjugateTranspose[r1], idMatrix]];
    Print[SameMatrix[r2.ConjugateTranspose[r2], idMatrix]];
    Print[Det[r1]];
    Print[Det[r2]];
 *)

    Print["decomposition: phi, theta, psi, delta, phi1, phi2"];
    (* Print[decomposeUnitary[r1]]; *)
    (* Print[decomposeUnitary[r2]]; *)

    angles1 = decomposeUnitary[r1];
    angles2 = decomposeUnitary[r2];

    Print["angles1"];
    Print[angles1/Pi];
    Print[Map[Sin, angles1]];
    Print[Map[Cos, angles1]];
    Print[Map[Tan, angles1]];
    Print[Map[Tan[#]^2&, angles1]];
    
    Print["angles2"];
    Print[angles2/Pi];
    Print[Map[Sin, angles2]];
    Print[Map[Cos, angles2]];
    Print[Map[Tan, angles2]];
    Print[Map[Tan[#]^2&, angles2]];

(* 
    eiphiby2 = Sqrt[Det[r1]];
    phi = Im[Log[Det[r1]]];
    r1Right = r1 / eiphiby2;

    theta = ArcCos[Abs[r1Right[[1]][[1]]]];
    eiphi1 = r1Right[[1]][[1]]/Cos[theta];
    eiphi2 = r1Right[[1]][[2]]/Sin[theta];
    phi1 = Im[Log[eiphi1]];
    phi2 = Im[Log[eiphi2]];
    psi = (phi1 + phi2)/2;
    delta = (phi1 - phi2)/2;

    Print["phi, theta, psi, delta, phi1, phi2"];
    Print[{phi, theta, psi, delta, phi1, phi2}/Pi];

    approximateR1 = Exp[I phi/2] {{Exp[I psi], 0}, {0, Exp[-I psi]}} . {{Cos[theta], Sin[theta]}, {-Sin[theta], Cos[theta]}} . {{Exp[I delta], 0}, {0, Exp[-I delta]}};

    Print["r1"];
    Print[SameMatrix[r1, approximateR1]];

    epsilon = 0.00001;
    minNonZero = Min[Select[Map[Abs, Flatten[realVertices]], # > epsilon&]];

    intersectionInverse = Intersection[realVertices, {realVertices[[1]] * (-1)}, SameTest -> SameVertex];
    containsInverse = Length[intersectionInverse] > 0; *)
    (* Print[shape <> ": " <> ToString[containsInverse]]; *)
];


(* 
phi = 2 Pi/p1 for r1, 2 Pi/p2 for r2
phi2 = - Pi/2 always

 *)