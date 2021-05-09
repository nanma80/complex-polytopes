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

(* symbols = {
    {3, 4, 4}
};
 *)
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

colors = {Red, Blue, Green, Magenta, Cyan, Brown, Pink, Purple};


For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];
    If[symbol[[1]] < 3, Continue[]];

    color = colors[[ Mod[symbolIndex, Length[colors] ] + 1]];

    imageSize = {1000, 750};

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];
    Print["Shape: " <> shape];

    frameFolder = shapeFile;

    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

    dataObject = Get[dataFileName];

    vertices = dataObject[["vertices"]];
    edges = dataObject[["edges"]];
    realVertices = Map[getReal, vertices];
    realEdges = Map[getReal, edges, {2}];

    seed = dataObject[["seed"]];
    r1 = dataObject[["r1"]];
    r2 = dataObject[["r2"]];

    p1 = symbol[[1]];
    q = symbol[[2]];
    p2 = symbol[[3]];
    h = 2/(1/p1 + 2/q + 1/p2 - 1);

    seed2 = r1.r2.seed;
    w = Transpose[Inverse[{ Transpose[seed][[1]], Transpose[seed2][[1]] }].{{1}, {Exp[2 Pi I / h]}}];
    realW = Map[getReal, w][[1]];
    wMatrix = {
        {realW[[1]], -realW[[2]], realW[[3]], -realW[[4]]}, 
        {realW[[2]], realW[[1]], realW[[4]], realW[[3]]},
        {1, 0, 0, 0},
        {0, 1, 0, 0}
    };
    
    projection4D = Orthogonalize[wMatrix];
    projectionTo2D = projection4D[[1;;2]];
    projectionTo3D = projection4D[[1;;3]];
    projectionTo3D = {
        projection4D[[1]],
        projection4D[[2]],
        projection4D[[3]]/1000
    };


    vertices3D = Map[(projectionTo3D.#)&, realVertices];
    edges3D = Map[(projectionTo3D.#)&, realEdges, {2}];

    maxZCenters = Max[Map[Abs[Total[#][[3]]]&, edges3D]];

    edgesEdges = Flatten[Map[getEdgesFromFace, edges3D], 1];

    range = Max[Map[Norm, vertices3D]] * 0.8;

    thickness = 0.008 * range;
    lighting = {{"Point", White, {10, -10, 10}}};

    graph = Graphics3D[
        {
            (* Map[{FaceForm[Hue[#[[3]]/maxZCenters/2 + 0.5, 1, 1, 1]], Sphere[#, thickness * 2]}&, vertices3D], *)
            (* Map[{FaceForm[Hue[Total[#][[3]]/maxZCenters/2 + 0.5, 1, 1, 1]], Cylinder[#, thickness]}&, edgesEdges], *)
            Map[{FaceForm[Hue[ ArcSin[Total[#][[3]]/maxZCenters]/2 + 0.5, 1, 1, 0.25]], Polygon[#]}&, edges3D]
        },
        ViewPoint -> {0, 0, 1000},
        PlotRange -> {{-range, range}, {-range, range}, {-range, range}},
        Lighting -> lighting
    ];

    outputFolder = FileNameJoin[{imageFolder, frameFolder}];
    If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

    outputFileName = shapeFile <> "_coxeter_faces" <> ".png";
    outputFileName = FileNameJoin[{outputFolder, outputFileName}];
    
    cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

    If[exportToPov,
        If[FileExistsQ[outputFileName], DeleteFile[outputFileName]];
        POVRayRender[graph, Method -> "Triangle", OutputPath -> outputFileName, ImageSize -> imageSize, RenderOptions -> "+A0.001 -J +UA"];
        Run[cropCommand];
        ,
        Export[outputFileName, graph];
    ];
    Print["Saved the image to " <> outputFileName]; 
];
