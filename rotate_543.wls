#!/usr/bin/env wolframscript


numericalValue = True;

exportToPov = True;
imageSize = {600, 450};
perspective = True;

(* rangeFactor = 0.8; *)
rangeFactor = 0.6;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

epsilon = 1*^-5;
iterationLimit = 20;
dataFolder = "data";
imageFolder = "output";

perspectiveProjection[point_, fullProjectionMatrix_, wDistance_ ] := projectToDirection[point, fullProjectionMatrix[[1;;3]]] / (1 + point.(fullProjectionMatrix[[4]])/wDistance);
projectToDirection[vertex4d_, projectionMatrix_] := projectionMatrix.vertex4d;
getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameVertex[point1_, point2_] := point1 == point2;
cubeVertices[dimension_] := 2 * Map[IntegerDigits[#, 2][[2;;dimension+1]]&, Table[k, {k, 2^dimension, 2 * 2^dimension - 1}]] - 1;
allPlusMinus[v_] := Union[Map[(v #)&, cubeVertices[Length[v]]]];
SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
sameCenter[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
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

beforePoints = {{-2.480383242146944, 0.5272217335747015, -1.7794269989971931, 0.3782288846496461},
 {-2.8453340453014464, 0.8558249127047565, -0.39329592993311957, -0.8698491358625313},
 {-2.117969759701417, -0.09708252957741059, -1.8043765278867538, -1.4102076950835576},
 {-2.870283574191017, -0.9326116670284419, -0.7557094123786414, -0.24554487271041892}};

(* Validate before points are indeed from realVertices. They are selected from an adhoc script *)
Print[Length[Intersection[realVertices, beforePoints, SameTest -> SameMatrix]] == Length[beforePoints]];

(* beforePoints = Flatten[Join[otherPoints, otherPoints2], 1]; *)
Print[Map[Norm, beforePoints]];
fourBeforePoints = beforePoints[[1;;4]];
Print[Det[fourBeforePoints]];


phi=(Sqrt[5]+1)/2;

theoreticalPoints = {
    {phi, 1, 0, 1/phi},
    {phi, 0, 1/phi, 1},
    {phi, 0, -1/phi, 1},
    {2, 0, 0, 0}
};

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
    Print[rotatedVertices//Length]; (* 600 *)

    cell600FileName = FileNameJoin[{dataFolder, "cell600Data.wl"}];

    If[!FileExistsQ[cell600FileName],
        cell600Cells = Get["../star-polytope/data/polytope_3_3_5_cell600.wl"];
        Print[cell600Cells//Length]; (* 600 *)
        cell600Faces = Union[ Flatten[cell600Cells, 1], SameTest -> sameCenter];
        Print[cell600Faces//Length]; (* 1200 *)
        cell600Edges = Union[ Flatten[Map[getEdgesFromFace, cell600Faces], 1], SameTest -> sameCenter];
        Print[cell600Edges//Length]; (* 720 *)
        cell600Vertices = Union[ Flatten[cell600Faces,1], SameTest -> sameVertex];
        Print[cell600Vertices//Length]; (* 120 *)

        cell600Data = <|
            "cells" -> cell600Cells,
            "faces" -> cell600Faces,
            "edges" -> cell600Edges,
            "vertices" -> cell600Vertices
        |>;

        Save[cell600FileName, cell600Data];
        Print["Saved 600-cell data to " <> cell600FileName];
    ];

    cell600Data = Get[cell600FileName];
    cell600Edges = cell600Data["edges"];
    cell600Vertices = cell600Data["vertices"];

    Print["Intersection of 600-cell vertices and 5{4}3 vertices"];
    (* 120. 3{4}5 vertices contain the 120 vertices of 600-cell *)
    Print[Intersection[N[cell600Vertices], rotatedVertices, SameTest -> SameMatrix]//Length];

    otherVertices = Complement[rotatedVertices, N[cell600Vertices], SameTest -> SameMatrix];
    (* 480 other vertices *)
    Print[otherVertices//Length];

    Print["Breaking edges to 3 parts"];

    getThirds[edge1_] := {
        Sin[2 Pi/15] edge1[[1]] + Sin[Pi/15] edge1[[2]],
        Sin[Pi/15] edge1[[1]] + Sin[2 Pi/15] edge1[[2]]
    }/Sin[4 Pi/5];

    selectedEdges = Select[cell600Edges, 
        Length[Intersection[getThirds[#], otherVertices, SameTest -> SameMatrix]]>0&
    ];
    Print[selectedEdges//Length]; (* 0 *)
    selectedEdgeEnds = Union[ Flatten[selectedEdges, 1], SameTest -> SameMatrix];
    Print[selectedEdgeEnds//Length]; (* 0 *)
    Print[Intersection[selectedEdgeEnds, N[cell600Vertices], SameTest -> SameMatrix]//Length]; (* 0 *)

(*     getSegments[edge1_] := 
    {
        {
            edge1[[1]],
            (Sin[2 Pi/15] edge1[[1]] + Sin[Pi/15] edge1[[2]])/Sin[4 Pi/5]            
        },
        {
            (Sin[2 Pi/15] edge1[[1]] + Sin[Pi/15] edge1[[2]])/Sin[4 Pi/5],
            (Sin[Pi/15] edge1[[1]] + Sin[2 Pi/15] edge1[[2]])/Sin[4 Pi/5]
        },
        {
            (Sin[Pi/15] edge1[[1]] + Sin[2 Pi/15] edge1[[2]])/Sin[4 Pi/5],
            edge1[[2]]
        }
    };
    selectedEdgeSegments = getSegments/@selectedEdges;
    edgeSegments = Flatten[selectedEdgeSegments, 1];
    Print[edgeSegments//Length]; (* 360 *)

    edgeThirds = Map[getThirds, cell600Edges];
    selectedEdgeThirds = Select[edgeThirds, Length[Intersection[#, otherVertices, SameTest -> SameMatrix]]>0&];
    Print[selectedEdgeThirds//Length]; (* 120 *)

    selectedVertices = Flatten[selectedEdgeThirds, 1];
    Print[selectedVertices//Length]; (* 240 *)
    (* 240. All the other vertices match the thirds points *)
    Print[Intersection[N[selectedVertices], otherVertices, SameTest -> SameMatrix]//Length];

    lighting = {{"Point", White, {10, -10, 10}}};
    range = If[perspective, 3, 1.6];
    thickness = 0.01 * range;

    projectionVector4D = {0, 0, 0, 1};
    positiveEdgeSegments = Select[edgeSegments, Total[#].projectionVector4D >= - 0.01 &];
    negativeEdgeSegments = Select[edgeSegments, Total[#].projectionVector4D < - 0.01 &];
    Print[Length/@{positiveEdgeSegments, negativeEdgeSegments}];

    fullProjectionMatrix = IdentityMatrix[4];
    projectionMatrix = fullProjectionMatrix[[1;;3]];
    wDistance = 2.01;

    edges3D = Map[perspectiveProjection[#, fullProjectionMatrix, wDistance]&, edgeSegments, {2}];
    vertices3D = Map[perspectiveProjection[#, fullProjectionMatrix, wDistance]&, selectedEdgeEnds];
    otherVertices3D = Map[perspectiveProjection[#, fullProjectionMatrix, wDistance]&, selectedVertices];

    graphElements = 
    If[perspective,
        {
            {
                FaceForm[Yellow], Map[Sphere[#, thickness * 4]&, vertices3D]
            },
            {
                FaceForm[Red], Map[Sphere[#, thickness * 3]&, otherVertices3D]
            },
            {
                FaceForm[Lighter[Red, 0.1]], Map[Cylinder[#, thickness * 2]&, edges3D]
            }
        },
        {
            {
                FaceForm[Yellow], Map[Sphere[#, thickness * 4]&, Map[projectToDirection[#, projectionMatrix]&, selectedEdgeEnds]]
            },
            {
                FaceForm[Lighter[Red, 0.1]], Map[Cylinder[#, thickness * 2.2]&, Map[projectToDirection[#, projectionMatrix]&, positiveEdgeSegments, {2}]]
            },
            {
                Opacity[0.5], FaceForm[Blue], Map[Cylinder[#, thickness * 2]&, Map[projectToDirection[#, projectionMatrix]&, negativeEdgeSegments, {2}]]
            }
        }
    ];

    frameIndexLimit = 24;
    For[ frameIndex = 1, frameIndex <= frameIndexLimit, frameIndex++,
        theta = Pi/2 * frameIndex / frameIndexLimit;
        graph = Graphics3D[
            graphElements,
            ViewVertical -> {0, 0, 1},
            ViewPoint -> {3 Cos[theta], - 3 Sin[theta], 1.3},
            (* ViewVertical -> {0, 1, 0}, *)
            (* ViewPoint -> {0, 0, 10}*3, *)
            PlotRange -> {{-range, range}, {-range, range}, {-range, range}},
            Lighting -> lighting
        ];

        (* Print[graph]; *)

        outputFileName = If[perspective, "perspective_", ""] <> "vertex_config_frame_" <> IntegerString[frameIndex, 10, 4] <> ".png";
        outputFileName = FileNameJoin[{imageFolder, shapeFile, outputFileName}];
        imageSize = {600, 450}; (* has to be 4:3 *)
        cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

        If[exportToPov,
            If[FileExistsQ[outputFileName], DeleteFile[outputFileName]];
            POVRayRender[graph, Method -> "Triangle", OutputPath -> outputFileName, ImageSize -> imageSize, RenderOptions -> "+A0.001 -J +UA"];
            Run[cropCommand];
            ,
            Export[outputFileName, graph];
        ]
        Print["Saved the image to " <> outputFileName]; 
    ];
 *)

    (* gif:
    magick convert -duplicate 1,-2-1 -quiet +repage -alpha remove -loop 0 -delay 10 -dispose 2 vertex_config_frame_*.png vertex_config.gif
    magick convert -duplicate 1,-2-1 -quiet +repage -alpha remove -loop 0 -delay 10 -dispose 2 perspective_vertex_config_frame_*.png perspective_vertex_config.gif
    magick convert -duplicate 1,-2-1 -quiet +repage -alpha remove -loop 0 -delay 10 -dispose 2 perspective_vertex_config_*.png perspective_vertex_config.gif

     *)
];


