#!/usr/bin/env wolframscript

angle[a_, b_, c_] := ArcCos[(Norm[a-c]^2 + Norm[b-c]^2 - Norm[a-b]^2)/(2 Norm[a-c] Norm[b-c])];
(* 5,6,2 *)
angle[realEdges[[1]][[1]], realEdges[[1]][[3]], realEdges[[1]][[2]]]
(* 108 deg *)
angle[realEdges[[1]][[1]], realEdges[[1]][[2]], {0, 0, 0, 0}]
(* 0.322642, 0.1027 Pi, 18.486 deg *)

(* 5, 4, 3 *)
(* same pentagon: 108 deg *)
angle[realEdges[[1]][[1]], realEdges[[1]][[2]], {0, 0, 0, 0}]
(* 0.378947, 0.120622 Pi, 21.712 deg *)



(* 120-cell *)
angle[faces[[1]][[1]], faces[[1]][[3]], faces[[1]][[2]]]
(* 108 deg *)
angle[faces[[1]][[1]], faces[[1]][[2]], {0, 0, 0, 0}]
(* In[42]:= angle[faces[[1]][[1]], faces[[1]][[2]], {0, 0, 0, 0}]//FullSimplify                                            
                1   3 Sqrt[5]
Out[42]= ArcCos[- + ---------]
                8       8
0.270919, 0.086236 Pi, 15.5225 deg
 *)
angle[realEdges[[1]][[1]], realEdges[[1]][[2]], {0, 0, 0, 0}]

maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
sameVertex[point1_, point2_] := point1 == point2;

shape = "Dodecahedron";
vertices = PolyhedronData[shape, "Vertices", "Coordinates"];
realVertices3d = vertices//N;

minSolution = NMinimize[ {maxNorm[{x1, x2, x3}, realVertices3d], {x1, x2, x3}.{x1, x2, x3} <= 1}, {x1, x2, x3}];

dimension3rd = {x1, x2, x3}/.minSolution[[2]];
rot3rd = Transpose[RotationMatrix[{dimension3rd, {0, 0, 1}}]];
realVertices3d.rot3rd

(* this is fine *)

maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
sameVertex[point1_, point2_] := point1 == point2;

cells = Get["../star-polytope/data/polytope_3_3_5_cell600.wl"];
faces = Flatten[cells, 1];
realVertices = Union[ Flatten[faces,1], SameTest -> sameVertex];

minNorm = 1000;
For[i = 2, i<=Length[realVertices], i++,
    norm = Norm[realVertices[[i]] - realVertices[[1]]];
    If[norm < minNorm, minNorm = norm];
];
minNorm / Norm[realVertices[[1]]]
(* 0.618 *)

(* 120 vertices on 600-cell *)


(* =========== *)
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
sameVertex[point1_, point2_] := point1 == point2;
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameCenter[edge1_, edge2_] := Total[edge1] == Total[edge2];

cells = Get["../star-polytope/data/polytope_3_3_5_cell600.wl"];
faces = Flatten[cells, 1];
(* edges = Union[ Flatten[Map[getEdgesFromFace, faces], 1], SameTest -> sameCenter]; *)
realVertices = Union[ Flatten[faces,1], SameTest -> sameVertex];

minSolution = NMinimize[ {maxNorm[{x1, x2, x3, x4}, realVertices], {x1, x2, x3, x4}.{x1, x2, x3, x4} <= 1 }, {x1, x2, x3, x4}];
dimension4th = {x1, x2, x3, x4}/.minSolution[[2]];
rot4th = Transpose[RotationMatrix[{dimension4th, {0, 0, 0, 1}}]];

(* minSolution: 2.61803 ^ 2 *)

realVertices.rot4th

maxNorm[{1, 0, 0, 0}, realVertices]
(* 2.618^2 *)

Select[realVertices, #[[4]]>2.617&]//Length
(* 20 *)

Select[realVertices.rot4th, #[[4]]>2.617&]//Length

minNorm = 1000;
For[i = 2, i<=Length[realVertices], i++,
    norm = 1.0 Norm[realVertices[[i]] - realVertices[[1]]];
    If[norm < minNorm, minNorm = norm];
];
minNormCount = 0;
For[i = 2, i<=Length[realVertices], i++,
    norm = 1.0 Norm[realVertices[[i]] - realVertices[[1]]];
    If[Abs[norm - minNorm] < 0.001, minNormCount++ ];
];

Print[minNorm / Norm[realVertices[[1]]]];
Print[minNormCount];

(* 0.270091 for 120-cell *)
(* 0.618034 for 600-cell *)

(* 24-cell *)
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
sameVertex[point1_, point2_] := point1 == point2;
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameCenter[edge1_, edge2_] := Total[edge1] == Total[edge2];

cells = Get["../star-polytope/data/polytope_3_4_3.wl"];
faces = Flatten[cells, 1];
(* edges = Union[ Flatten[Map[getEdgesFromFace, faces], 1], SameTest -> sameCenter]; *)
realVertices = Union[ Flatten[faces,1], SameTest -> sameVertex];
minNorm = 1000;
For[i = 2, i<=Length[realVertices], i++,
    norm = 1.0 Norm[realVertices[[i]] - realVertices[[1]]];
    If[norm < minNorm, minNorm = norm];
];
minNorm / Norm[realVertices[[1]]]
(* 24-cell: 1 *)


symbols = {
    (* {3, 3, 3} *)
    (* {3, 5, 3} *)
    {5, 3, 5}
	(* {4, 4, 2} *)
    (* {3, 4, 3} *)
    (* {5, 4, 2} *)
    (* , {2, 4, 5} *)
    (* {3, 6, 2} *)
    (* , {3, 3, 2} *)
    (* , {3, 5/2, 3} *)
    (* {5, 3, 2} *)
    (* {5, 6, 2} *)
    (* {5, 4, 3} *)
};

symbol = symbols[[1]];

exportToPov = True;
dataFolder = "data";
imageFolder = "output";

imageSize = {600, 450};

rangeFactor = 0.8;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];

getProjectionMatrix[direction_] := Simplify[Orthogonalize[{direction, {0.3, 510.234, 0.5, 0}, {0, 0.2, 1000, 0}, {0, 1.3, 0, -1000}}]][[2;;4]];
getProjectionMatrix2[direction_, direction2_] := Simplify[Orthogonalize[{direction, {0, 10, 0,  1}, direction2, {-3, 3, -5, 0}}]][[2;;4]];
projectToDirection[vertex4d_, projectionMatrix_] := projectionMatrix.vertex4d;
projectTo3d[vertex4d_] := {vertex4d[[1]], vertex4d[[2]], vertex4d[[3]]};
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameVertex[point1_, point2_] := point1 == point2;
sameCenter[edge1_, edge2_] := Total[edge1] == Total[edge2];
sameCellCenter[cell1_, cell2_] := getCellCenter[cell1] == getCellCenter[cell2];
getFaceCenter[face_] := Simplify[Total[face]];
getCellCenter[cell_] := Simplify[Total[Flatten[cell, 1]]];

dataFolder = "data";

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];

dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

Print["Reading data for " <> shape <> " from " <> dataFileName];

dataObject = Get[dataFileName];

edges = dataObject[["edges"]];
vertices = dataObject[["vertices"]];

realVertices = Map[getReal, vertices];
realEdges = Map[getReal, edges, {2}];

realVertices = dataObject[["rotatedRealVertices"]];
realEdges = dataObject[["rotatedRealEdges"]];

(* topCell = Select[realVertices, #[[4]]>3.476&]; *)
topCell = Select[realVertices, #[[4]]>2.940&];



topCell1 = Select[topCell, #[[1]] > 0&];
topCell2 = Select[topCell, #[[1]] < 0&];
rotation = ArrayFlatten[{{1, 0, 0}, {0, RotationMatrix[Pi/4], 0}, {0, 0, 1}}];
topCell1 = topCell1.rotation;
topCell2 = topCell2.rotation;

(* 562 *)
(* two pentagons, parallel, rotated by 90 deg, offset by a distance *)

(* 543 *)
(* two pentagons, parallel, rotated by 180 deg x-y plane. z unchanged*)
(* realEdges on top cell: *)
edge1 = {{-0.7431447945162486, 0.6146483292065783, 0.4067366474504641, 2.940100315232136}, {-0.6146483031407733, 0.4067366382630112, -0.7431448211032636, 2.9401003152321947}, {3.004413232088332*^-8, -0.5877852575429159, -0.8660253994128714, 2.940100307269696}, {0.25137709970539823, -0.9945219007633906, 0.2079116951882746, 2.9401003023485437}, {-0.20791166043649467, -0.25137707493775785, 0.994521899740704, 2.940100307269604}}
edge2 = {{0.20791172155393728, 0.2513770645504517, 0.9945218997030879, 2.9401003038484643}, {-0.25137703867221567, 0.9945218903280665, 0.20791169515449148, 2.940100311099103}, {3.087401280466029*^-8, 0.58778524704203, -0.866025399448753, 2.940100309358466}, {0.6146483640720816, -0.40673664875639576, -0.743144821144273, 2.940100301032051}, {0.743144855570729, -0.614648339629767, 0.4067366474083826, 2.9401002976266835}}
edge1//MatrixForm
edge2//MatrixForm

(* edge1:
    -0.743145      0.614648       0.406737       2.9401
    -0.614648      0.406737       -0.743145      2.9401
    0              -0.587785      -0.866025      2.9401
    0.251377       -0.994522      0.207912       2.9401
    -0.207912      -0.251377      0.994522       2.9401
edge2:
    0.207912      0.251377      0.994522      2.9401
    -0.251377     0.994522      0.207912      2.9401
    0             0.587785      -0.866025     2.9401
    0.614648      -0.406737     -0.743145     2.9401
    0.743145      -0.614648     0.406737      2.9401
 *)

(* 
0.866025 = Sqrt[3]/2 
0.587785 = sqrt[(5-sqrt(5))/8]

*)

minNorm = 1000;
For[i = 2, i<=Length[realVertices], i++,
    norm = 1.0 Norm[realVertices[[i]] - realVertices[[1]]];
    If[norm < minNorm, minNorm = norm];
];
minNormCount = 0;
For[i = 2, i<=Length[realVertices], i++,
    norm = 1.0 Norm[realVertices[[i]] - realVertices[[1]]];
    If[Abs[norm - minNorm] < 0.001, minNormCount++ ];
];

Print[minNorm / Norm[realVertices[[1]]]];
Print[minNormCount];
(* 562: 0.312869 *)
(* this is wrong! *)
(* 543: 0.209057, wrong too *)
(* 120-cell: 0.270091 *)
(* 535: 0.618. as same as 600-cell *)
(* 353: 0.618, correct. as same as 600-cell *)
(* 362: 0.796225 *)

norms = Map[Norm, realVertices];


2.9401

minSolution = NMinimize[ {maxNorm[{x1, x2, x3, x4}, realVertices], {x1, x2, x3, x4}.{x1, x2, x3, x4} <= 1 }, {x1, x2, x3, x4}];
dimension4th = {x1, x2, x3, x4}/.minSolution[[2]];
rot4th = Transpose[RotationMatrix[{dimension4th, {0, 0, 0, 1}}]];

(* minSolution: 2.61803 ^ 2 *)

minSolution[[1]]//Sqrt
(* 562: 3.47681 *)
(* 543: 2.9401 *)
realVertices.rot4th

maxNorm[{1, 0, 0, 0}, realVertices]
(* 2.618^2 *)

Select[realVertices.rot4th, #[[4]]>3.476&]//Length
(* 10 *)

Select[realVertices.rot4th, #[[4]]<-3.476&]//Length
(* 10 *)

(* data is wrong? *)

dimension4th = {x1, x2, x3, x4}/.NMinimize[ {maxNorm[{x1, x2, x3, x4}, realVertices], {x1, x2, x3, x4}.{x1, x2, x3, x4} <= 1 }, {x1, x2, x3, x4}][[2]];
rot4th = Transpose[RotationMatrix[{dimension4th, {0, 0, 0, 1}}]];
realVertices3d = Transpose[Transpose[realVertices.rot4th][[1;;3]]];

dimension3rd = {x1, x2, x3}/.NMinimize[ {maxNorm[{x1, x2, x3}, realVertices3d], {x1, x2, x3}.{x1, x2, x3} <= 1}, {x1, x2, x3}][[2]];
rot3rd = Transpose[RotationMatrix[{dimension3rd, {0, 0, 1}}]];
rot3rd4D = ArrayFlatten[{{rot3rd, 0},{0, 1}}];

Map[#.rot4th.rot3rd4D&, realEdges]

realVertices2d = Transpose[Transpose[realVertices3d.rot3rd][[1;;2]]];
dimension2nd = {x1, x2}/.NMinimize[ {maxNorm[{x1, x2}, realVertices2d], {x1, x2}.{x1, x2} <= 1}, {x1, x2}][[2]];
rot2nd = Transpose[RotationMatrix[{dimension2nd, {0, 1}}]];
rot2nd4D = ArrayFlatten[{{rot2nd, 0}, {0, IdentityMatrix[2]}}];
rot4D = rot4th.rot3rd4D.rot2nd4D;
rotatedRealVertices = realVertices.rot4D;
rotatedRealEdges = Map[#.rot4D&, realEdges];






realVertices3d.rot3rd

rot3rd
