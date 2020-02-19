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

symbols = { {3, 6, 2} };

epsilon = 0.00001;

dataFolder = "data";
imageFolder = "output";
scaling = False;

SameFloat[v1_, v2_] := Abs[v1 - v2] < epsilon;
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

nVector[r1_, p1_] := Module[{n1Matrix, n11, n12, epsilon}, 
    epsilon = 0.000001;
    n1Matrix = (r1 - IdentityMatrix[2])/(Exp[2 Pi I / p1] - 1);
    n11 = Sqrt[Re[n1Matrix[[1]][[1]]]];
    n12 = n1Matrix[[1]][[2]]/n11;
    If[Abs[Im[n12]] < epsilon, n12 = Re[n12]];
    (* these two tests are always true *)
    (* Print[SameFloat[n11 Conjugate[n12], n1Matrix[[2]][[1]]]]; *)
    (* Print[SameFloat[Abs[n12]^2, n1Matrix[[2]][[2]]]]; *)
    {n11, n12}
];

dataFolder = "data";

idMatrix = IdentityMatrix[2];

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];

    p1 = symbol[[1]];
    q = symbol[[2]];
    p2 = symbol[[3]];

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];

    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

    dataObject = Get[dataFileName];

    vertexFileName = FileNameJoin[{dataFolder, "vertices", shapeFile <> If[scaling, "_scaled", ""] <> "_vertices.txt"}];

    realVertices = dataObject[["rotatedRealVertices"]];

    r1 = dataObject[["r1"]];
    r2 = dataObject[["r2"]];
    seed = dataObject[["seed"]];

    (* Print[]; *)
    Print[shape];
    (* Print["r1, r2"] *)
    (* Print[r1]; *)
    (* Print[r2]; *)

    n1 = nVector[r1, symbol[[1]]];
    n2 = nVector[r2, symbol[[3]]];

    rot45 = RotationMatrix[-Pi/4];
    (* Print[rot45]; *)
    newn1 = n1 . rot45;
    newn2 = n2 . rot45;

    newr1 = IdentityMatrix[2] + (Exp[2 Pi I / p1] - 1) (Transpose[{newn1}] . {newn1});
    newr2 = IdentityMatrix[2] + (Exp[2 Pi I / p2] - 1) (Transpose[{newn2}] . {newn2});

    Print[newr1];
    Print[newr2];

    (* these are all confirmed *)
    (* Print[SameMatrix[newr1, Transpose[rot45].r1.rot45]]; *)
    (* Print[SameMatrix[newr2, Transpose[rot45].r2.rot45]]; *)
    (* Print[SameMatrix[newr1.ConjugateTranspose[newr1], IdentityMatrix[2]]]; *)
    (* Print[SameMatrix[newr2.ConjugateTranspose[newr2], IdentityMatrix[2]]]; *)

    newSeed = Transpose[rot45] . seed;
    Print[newSeed];
    Print[newr2.newSeed];

    Print[seed];
    Print[r2.seed];

    (* n1 = {a, -b}, n2 = {b, -a}. Both are always unit norm *)
    (* Print[n1]; *)
    (* Print[n2]; *)
    (* Print[{Norm[n1], Norm[n2]}]; *)

    (* n1: a > b, always *)
    (* Print[Abs[n1[[1]]] > Abs[n1[[2]]]]; *)

    twosigma = ArcCos[(Cos[Pi/p1] Cos[Pi/p2] + Cos[2 Pi/q])/(Sin[Pi/p1] Sin[Pi/p2])];
    Print[twosigma//N];

    Print[newn1];
    Print[{Cos[twosigma/4], Sin[twosigma/4]}//N];

    Print[newn2];
    Print[{Cos[twosigma/4], -Sin[twosigma/4]}//N];

    (* Print[n1 . n2]; *)
    cosHalfSigma = Sqrt[(Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])] + 1)/2];
    (* cosHalfSigma = Assuming[p1 > 0 && p2 > 0 && q > 0, FullSimplify[cosHalfSigma]]; *)

    halfSigma = ArcCos[cosHalfSigma];

    theta1 = -Pi/4 + halfSigma;
    theta2 = -Pi/4 - halfSigma;
    (* Print[SameMatrix[n1, {Cos[theta1], Sin[theta1]}]]; *)
    (* Print[SameMatrix[n2, {Cos[theta2], Sin[theta2]}]]; *)
    n1Precise = {Cos[theta1], Sin[theta1]};
    n2Precise = {Cos[theta1], Sin[theta1]};
    (* Print[n1Precise]; *)
    (* Print[n2Precise]; *)

    (* n1 . n2 == Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])]] *)
    (* that sqrt is -a12 in the original construction *)
    (* Print[Abs[n1.n2 - Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])]] < epsilon]; *)

    (* when n1 = {a, -b}, seed == {a, b} / (a^2 - b^2) *)
    (* Print[SameMatrix[ (Transpose[seed])[[1]], {n1[[1]], -n1[[2]]}/(n1[[1]]^2 - n1[[2]]^2) ]]; *)
    (* Print[seed/Norm[seed]]; *)
    (* Print[{n1[[1]], -n1[[2]]}/(n1[[1]]^2 - n1[[2]]^2)]; *)

    (* n1.seed == 1, n2.seed == 0*)
    (* Print[Abs[(n1 . seed)[[1]] - 1] < epsilon ]; *)
    (* Print[Abs[(n2 . seed)[[1]]] < epsilon]; *)


(*     Print[SameMatrix[r1.ConjugateTranspose[r1], idMatrix]];
    Print[SameMatrix[r2.ConjugateTranspose[r2], idMatrix]];
    Print[Det[r1]];
    Print[Det[r2]];
 *)

    (* Print["decomposition: phi, theta, psi, delta, phi1, phi2"]; *)
    (* Print[decomposeUnitary[r1]]; *)
    (* Print[decomposeUnitary[r2]]; *)

(*     angles1 = decomposeUnitary[r1];
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
 *)

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