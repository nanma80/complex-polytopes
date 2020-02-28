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

symbols = { {5, 4, 3} };

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
    realEdges = dataObject[["rotatedRealEdges"]];

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

    (* Print[newr1]; *)
    (* Print[newr2]; *)

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
    Print[twosigma];
    sigma = twosigma/2;

    Print["cos sigma"];
    Print[Cos[sigma]//FullSimplify];
    Print[Cos[sigma]//N];
    Print[n1.n2];

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

    Print[realEdges//Length];
    
    vertex1 = realEdges[[1]][[1]];
    incidentEdges = Select[realEdges, Length[Intersection[#, {vertex1}, SameTest -> SameMatrix]] > 0&];
    incidentEdgeCenters = Mean/@incidentEdges;
    incidentEdgeCenters = incidentEdgeCenters/Norm[incidentEdgeCenters[[1]]];

    vertex1 = vertex1/Norm[vertex1];
    Print[incidentEdgeCenters//Length];

    Print[incidentEdgeCenters[[1]].incidentEdgeCenters[[2]]];
    Print[incidentEdgeCenters[[1]].vertex1];


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


(* 
3{3}3: based on 16-cell. two generators are a vertex and a 2d face center.
the vertex is (0, 0, 0, 1).
face: (0, 0, 0, 1), (1, 0, 0, 0), (0, 1, 0, 0)
normalized center: (1, 1, 0, 1)/Sqrt[3]
inner prod: 1/Sqrt[3]. matching Cos[sigma].

3{4}3: based on 24-cell. the two generators are around
a vertex and a 2d face center.
In the vertex first orientation, a vertex is (0,0,0,1)
a face has 3 vertices: (0,0,0,1), (1/2, 1/2, 1/2, 1/2), (1/2, 1/2, -1/2, 1/2)
center: (1/3, 1/3, 0, 2/3). norm(center) = sqrt(6)/3
normalized center = (1,1,0,2)/sqrt(6)
inner prod: 2/sqrt(6)=sqrt(2/3), which matches the theoretical value, Cos[sigma]=Sqrt[2/3]

4{3}4: based on 24-cell. vertex and and a square (equator of an octahedron).
vertex: (0,0,0,1). 
face center, mid point between (0,0,0,1) to (1,0,0,0). (1,0,0,1)/Sqrt[2]
inner prod: 1/Sqrt[2]. Correct.

3{5}3: based on 600-cell. vertex and a triangle.
vertex: {1,0,0,0}
face: 
{1,0,0,0}, {phi, 1, 1/phi, 0}/2, {phi, 1, -1/phi, 0}/2
{1,0,0,0}, {phi, 0, 1, 1/phi}/2, {phi, -1, 1/phi, 0}/2
normalized face center: {1 + phi, 1, 0, 0}/Sqrt[1+(1+phi)^2]
inner prod:
Sqrt[(3 + Sqrt[5])/6]
0.9341723589627157
Correct


5{3}5: based on 600-cell. Vertex and a pentagon.

face = {
 {phi, 1, 1/phi, 0}/2,
 {phi, 1, -1/phi, 0}/2,
 {phi, 0, 1, 1/phi}/2,
 {phi, 0, -1, 1/phi}/2,
 {phi, -1/phi, 0, 1}/2
};
vertex =  {phi, -1/phi, 0, 1}/2;
Dot[vertex, faceCenter]//FullSimplify//InputForm
Sqrt[(5 + Sqrt[5])/10]
0.85065080835204
it is equal to Cos[ArcSec[Sqrt[5]]/2]. So, correct.


3{6}2:
Truncated 3{3}3, which has 
the vertex = (0, 0, 0, 1).
and the normalized face enter: (1, 1, 0, 1)/Sqrt[3]
The middle point = {1/Sqrt[3], 1/Sqrt[3], 0, 1/Sqrt[3] + 1}/(its norm)
inner product between the middle point and the vertex = the last component 
of the middle point. 
(1/Sqrt[3] + 1)/Sqrt[2/3 + (1/Sqrt[3] +1)^2]
= Sqrt[(3 + Sqrt[3])/6]
As same as:
Cos[ArcSec[Sqrt[3]]/2]
0.8880738339771153
mid1={1/Sqrt[3], 1/Sqrt[3], 0, 1/Sqrt[3] + 1}/(its norm)
mid2= mid1 rotating components 4->1->2
Norm[mid1-mid2]/Norm[mid1] = Sqrt[3/(3 + Sqrt[3])] = 0.7962252170181258
matching previous result

The 16-cell has another set of vertex coordinates based on cell first.
vertex = {1, -1, -1, 1}
face = 
{{1, -1, -1, 1},
{-1, 1, -1, 1},
{-1, -1, 1, 1}}
The result is the same. The form of the mid point is not better.

3{8}2:
Truncated 3{4}3, which has
vertex = {0,0,0,1};
faceCenter = {1,1,0,2}/Sqrt[6];
mid = (vertex + faceCenter);
mid = mid/Norm[mid]//FullSimplify;
mid.vertex : Sqrt[1/2 + 1/Sqrt[6]]
0.9530206138714226
x = mid.vertex
y = Cos[ArcCos[Sqrt[2/3]]/2]
Correct.
mid (not normalized) = {1, 1, 0, 2 + Sqrt[6]}
face = {{0,0,0,1}, {1/2, 1/2, 1/2, 1/2}, {1/2, 1/2, -1/2, 1/2}}

3{10}2:
Truncated 3{5}3
vertex= {1,0,0,0};
faceCenter= {1 + phi, 1, 0, 0}/Sqrt[1+(1+phi)^2]/.phi->GoldenRatio;
mid = (vertex + faceCenter);
mid = mid/Norm[mid]//FullSimplify;
x = mid.vertex
0.9834053993554022
y = Cos[ArcCos[Sqrt[(3 + Sqrt[5])/6]]/2]
x = Sqrt[2 + Sqrt[(2*(3 + Sqrt[5]))/3]]/2
Same.

4{6}2
Truncated 4{3}4
sigma = Pi/8
Cos[Pi/8]
0.9238795325112867

from 4{3}4:
vertex= {0,0,0,1};
faceCenter= {1,0,0,1}/Sqrt[2];
mid = (vertex + faceCenter);
mid = mid/Norm[mid]//FullSimplify;
x = mid.vertex
x = Sqrt[2 + Sqrt[2]]/2
0.9238795325112867
Correct.

5{6}2
Truncated 5{3}5
cos sigma = Cos[ArcCos[Sqrt[(5 + Sqrt[5])/10]]/2]
0.9619383577839175

phi = GoldenRatio;
face = {
 {phi, 1, 1/phi, 0}/2,
 {phi, 1, -1/phi, 0}/2,
 {phi, 0, 1, 1/phi}/2,
 {phi, 0, -1, 1/phi}/2,
 {phi, -1/phi, 0, 1}/2
};
vertex =  {phi, -1/phi, 0, 1}/2;
faceCenter = Total[face]/Norm[Total[face]]//FullSimplify                                                       
mid = (vertex + faceCenter);
mid = mid/Norm[mid]//FullSimplify;
x = mid.vertex
x: Sqrt[2 + Sqrt[2 + 2/Sqrt[5]]]/2
0.9619383577839176

matches y = Cos[ArcCos[Sqrt[(5 + Sqrt[5])/10]]/2]

sigma562 = ArcCos[Sqrt[(5 + Sqrt[5])/10]]/2

4{4}3
cos sigma
Cos[ArcSec[Sqrt[3]]/2]
0.8880738339771153

this is identical to the inner product of 3{6}2, which is between
the vertex = (0, 0, 0, 1).
and the middle point = {1/Sqrt[3], 1/Sqrt[3], 0, 1/Sqrt[3] + 1}/(its norm)

Each vertex of 2{6}3 is a 2-edge, connecting a 16-cell vertex to a face center (rescaled). 
Equivalently, it's connecting a 24-cell center to a face center (rescaled). Only 8 cell centers are used. Only 16 edges.
To construct 4{4}3, we use all 24 cell centers of a 24-cell. Each cell center is used in 3 edges, 24*3 = 72 edges in total.
Each edge is a 4-edge, the cell center and a face center are diagonal vertices of the 4-edge.
Once the diagonals are determined, the other two vertices of each 4-edge can be determined by:

the vector from the 4-edge center to the cell center and the vector from the 4-edge center to the new point are orthogonal,
and the lengths are the same
the same for another 4-edge
the distance from two 4-edge centers to the new point is the same

cc1 = {0, 0, 0, 2 Sqrt[3]};
fc1 = {2, 2, 0, 2};
cc2 = {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]};
fc2 = {1, -1, 1, 3};
mid1 = (fc1 + cc1)/2//Simplify;
mid2 = (fc2 + cc2)/2//Simplify;

solution = Solve[ Dot[{x1,x2,x3,x4}-mid1, fc1-mid1] == 0
                && Dot[{x1,x2,x3,x4}-mid2, fc2-mid2] == 0
                && Dot[{x1,x2,x3,x4}, mid1] == Dot[cc1, mid1]
                && Dot[{x1,x2,x3,x4}, mid2] == Dot[cc2, mid2]
                , 
            {x1,x2,x3,x4}]
newPoint = {x1,x2,x3,x4}/.solution//FullSimplify
=> {{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}}



5{4}3
cos sigma = Cos[ArcCos[Sqrt[(5 + 2*Sqrt[5])/15]]/2]
0.9472735804116376
alt forms:
Sqrt[(1 + Sqrt[(5 + 2*Sqrt[5])/15])/2]
Sqrt[(15 + Sqrt[75 + 30*Sqrt[5]])/30]

Cos[2*sigma]:
cos2sigma543 = Sqrt[(5 + 2*Sqrt[5])/15] = 0.7946544722917661

phi=(Sqrt[5]+1)/2;
face = {
 {phi, 1/phi, 1, 0}/2,
 {phi, -1/phi, 1, 0}/2,
 {1, 0, 0, 0}
};
faceCenter = Mean[face]/Norm[Mean[face]]//FullSimplify
edgeCenter = Mean[{{phi, 1/phi, -1, 0}/2, {1, 0, 0, 0}}];
edgeCenter = edgeCenter / Norm[edgeCenter] //Simplify;
N[faceCenter.edgeCenter]
=> Sqrt[(5 + 2*Sqrt[5])/15]
mid = Mean[{edgeCenter, faceCenter}];
mid = mid/Norm[mid]//FullSimplify;
mid.faceCenter
Equal to: Cos[ArcCos[Sqrt[(5 + 2*Sqrt[5])/15]]/2]

In {3,3,5}, an edge is a 5 fold axis, a face is a 3 fold axis.

faceCenter:
{(3 + Sqrt[5])/3, 0, 2/3, 0}

edgeCenter:
{(5 + Sqrt[5])/4, (1 + Sqrt[5])^(-1), -1/2, 0}

There are diff ways to choose edge and face that result in the same inner product.

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

edgeCenterx and edgeCentery are aligned with the face center. The axes of rotational
symmetry of the face and the edge are the same: z axis.

But the mid point?
midy == {0.770582, 0., 0.637341, 0.}


*)