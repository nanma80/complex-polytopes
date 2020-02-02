#!/usr/bin/env wolframscript


numericalValue = True;
exportToPov = True;
dataFolder = "data";
imageFolder = "output";

epsilon = 1*^-5;
iterationLimit = 20;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];


SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];

(* symbol = {2, 6, 5}; *)
(* symbol = {5, 6, 2}; *)
(* {5, 4, 3} *)
(* symbol = {3, 4, 5}; *)
(* symbol = {5, 4, 3}; *)
(* symbol = {3, 10, 2}; *)
symbol = {2, 10, 3};

color = Cyan;

frameFolder = "static_test";

p1 = symbol[[1]];
q = symbol[[2]];
p2 = symbol[[3]];
h = 2/(1/p1 + 2/q + 1/p2 - 1);

qDisplayString = getQString[q, "/"];
qFileString = getQString[q, "over"];

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];
Print["Shape: " <> shape];

seed = {{1}, {0}};
If[numericalValue, seed = seed * 1.0];

e1 = Exp[Pi I / p1];
e2 = Exp[Pi I / p2];
a12 = - Sqrt[(Cos[Pi/p1 - Pi/p2] + Cos[2 Pi/q])/(2 Sin[Pi/p1] Sin[Pi/p2])] //FullSimplify;
a21 = a12;

r1 = {{e1^2, 0}, {(e1^2 - 1) a21, 1}}//FullSimplify//ExpToTrig;
r2 = {{1, (e2^2 - 1) a12}, {0, e2^2}}//FullSimplify//ExpToTrig;

a = {{1, a12}, {a21, 1.}};
ai = Inverse[a];
half = MatrixPower[ai, 1/2];

seed = half.seed;
r1 = half.r1.Inverse[half]//FullSimplify//ExpToTrig;
r2 = half.r2.Inverse[half]//FullSimplify//ExpToTrig;

(* seed2 = MatrixPower[r1.r2, 15].seed;
w = Transpose[Inverse[{ Transpose[seed][[1]], Transpose[seed2][[1]] }].{{1}, {I}}];
 *)
seed2 = r1.r2.seed;
w = Transpose[Inverse[{ Transpose[seed][[1]], Transpose[seed2][[1]] }].{{1}, {Exp[2 Pi I / h]}}];


(* imageSize = {600, 450}; *)
imageSize = {1000, 750};

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];

dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

dataObject = Get[dataFileName];

vertices = dataObject[["vertices"]];
edges = dataObject[["edges"]];

vertices2D = Map[getReal[w.#] &, vertices];
edges2D = Map[getReal[w.#] &, edges, {2}];
edges2D = Map[Join[#, {#[[1]]}]&, edges2D];

vertices3D = Map[{#[[1]], #[[2]], 0}&, vertices2D];
edges3D = Map[{#[[1]], #[[2]], 0}&, edges2D, {2}];
(* edges3D = edges3D[[1;;10]]; *)
edgesEdges = Flatten[Map[getEdgesFromFace, edges3D], 1];

range = Max[Map[Norm, vertices3D]] * 0.8;

(* graphVertices = ListPlot[vertices2D,
    AspectRatio -> 1,
    Axes -> False,
    PlotRange -> All
];

graphEdges = ListLinePlot[edges2D,
    AspectRatio -> 1,
    Axes -> False,
    PlotRange -> All
];
 *)

thickness = 0.008 * range;
lighting = {{"Point", White, {10, -10, 10}}};

graph = Graphics3D[
    {
        {
            FaceForm[Yellow], Map[Sphere[#, thickness * 2]&, vertices3D]
        },
        {
            Opacity[0.5], FaceForm[color], Map[Cylinder[#, thickness]&, edgesEdges]
        }
    },
    ViewPoint -> {0, 0, 1},
    PlotRange -> {{-range, range}, {-range, range}, {-range, range}},
    Lighting -> lighting
];

outputFolder = FileNameJoin[{imageFolder, frameFolder}];
If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

outputFileName = shapeFile <> "_coxeter_edges" <> ".png";
outputFileName = FileNameJoin[{outputFolder, outputFileName}];

cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

If[exportToPov,
    If[FileExistsQ[outputFileName], DeleteFile[outputFileName]];
    POVRayRender[graph, Method -> "Triangle", OutputPath -> outputFileName, ImageSize -> imageSize, RenderOptions -> "+A0.001 -J +UA"];
    Run[cropCommand];
    ,
    Export[outputFileName, graph];
]
Print["Saved the image to " <> outputFileName]; 




