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

symbols = { {3, 4, 5} };

exportToPov = True;
dataFolder = "data";
imageFolder = "output";

imageSize = {600, 450};

(* rangeFactor = 0.8; *)
rangeFactor = 0.4;
epsilon = 0.0000001;
greatestNormVertical = False;

Needs["POVRayRender`"];
ConfigurePOVRayRender["POVRayPath" -> "C:\\Program Files\\POV-Ray\\v3.7\\bin\\pvengine64.exe"];

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
SameTotal[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];
getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];

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

symbol = symbols[[1]];
theta = 0;
phi3d = 0;
serialNumber = 1;
frameFolder = "test";

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];

dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

Print["Reading data for " <> shape <> " from " <> dataFileName];

dataObject = Get[dataFileName];

edges = dataObject[["edges"]];
vertices = dataObject[["vertices"]];

Print["Vertex count: " <> IntegerString[Length[vertices]] <> " Edge count: " <> IntegerString[Length[edges]] ];

realVertices = Map[getReal, vertices];
realEdges = Map[getReal, edges, {2}];

thickness = Norm[vertices[[1]]] * 0.01;
lighting = {{"Point", White, {10, -10, 10}}};
range = Norm[vertices[[1]]] * rangeFactor;

outputFolder = FileNameJoin[{imageFolder, frameFolder}];
If[!DirectoryQ[outputFolder], CreateDirectory[outputFolder]];

outputFileName = shapeFile <> "_animation_frame_vertexFirst_" <> IntegerString[serialNumber, 10, 4] <> ".png";
outputFileName = "center_" <> outputFileName;
outputFileName = FileNameJoin[{outputFolder, outputFileName}];

cropCommand = "mogrify -crop " <> IntegerString[imageSize[[2]]] <> "x" <> IntegerString[imageSize[[2]]] <> "+" <> IntegerString[(imageSize[[1]]-imageSize[[2]])/2] <> "+0 " <> outputFileName;

(* projectionVector4D = {Cos[theta], -Sin[theta]/5, 0,  - Sin[theta]}; *)
vertex1 = realEdges[[1]][[1]];
projectionVector4D = vertex1 + {0.000001, 0, 0.0000061, 0.0000021};

projectionTo3D = getProjectionMatrix[projectionVector4D];
(* projectionTo3D = getProjectionMatrix2[{1, 1, 0, 0}, {1, 0, 0, 0}]; *)
(* projectionTo3D = IdentityMatrix[4][[1;;3]]; *)

incidentEdges = Select[realEdges, Length[Intersection[#, {vertex1}, SameTest -> SameMatrix]] > 0&];
incidentEdgeCenters = Mean/@incidentEdges;
Print["incident edge count: " <> ToString[incidentEdgeCenters//Length]];

If[greatestNormVertical,
    firstProjectionTo3D = Map[projectToDirection[#, projectionTo3D]&, realVertices];
    maxNorm = 0;
    maxVertexIndex = -1;
    For[vertexIndex = 1, vertexIndex <= Length[firstProjectionTo3D], vertexIndex++,
        If[maxNorm < Norm[firstProjectionTo3D[[vertexIndex]]],
            maxNorm = Norm[firstProjectionTo3D[[vertexIndex]]];
            maxVertexIndex = vertexIndex
        ];
    ];

    Print[maxNorm];
    Print[maxVertexIndex];

    viewVertical = firstProjectionTo3D[[maxVertexIndex]];
    Print[viewVertical],

    If[Length[incidentEdges] <= 2,
        viewVertical = projectToDirection[(incidentEdgeCenters[[1]] - vertex1), projectionTo3D],
        vector1 = projectToDirection[(incidentEdgeCenters[[1]] - vertex1), projectionTo3D];
        vector2 = vector1;
        For[index2 = 2, index2 <= Length[incidentEdges], index2++,
            vector2 = projectToDirection[(incidentEdgeCenters[[index2]] - vertex1), projectionTo3D];
            If[Abs[(vector1.vector2)/(vector1.vector1)] < 1 - 0.001,
                Break[];
            ];
        ];
        Print["dot product: " <> ToString[InputForm[Abs[(vector1.vector2)/(vector1.vector1)]]]];
        viewVertical = Orthogonalize[{vector1, vector2, {0.3, 510.234, 0.5}}][[3]]
    ];
];

projectionMatrix = RotationMatrix[- phi3d, {0, 0, 1}].RotationMatrix[{viewVertical, {0, 0, 1}}].projectionTo3D;
(* projectionMatrix = RotationMatrix[- phi3d, viewVertical].projectionTo3D; *)

graphElements = {
    {
        (* FaceForm[Yellow], Map[Sphere[#, thickness * 3]&, Map[projectToDirection[#, projectionMatrix]&, realVertices]] *)
    }
};

positiveEdges = Select[realEdges, Total[#].projectionVector4D >= - 0.1 &];
negativeEdges = Select[realEdges, Total[#].projectionVector4D < - 0.1 &];

positiveEdges = Select[realEdges, Mean[#].projectionVector4D >= 8.5 &];
negativeEdges = Select[realEdges, Total[#].projectionVector4D < - 100.1 &];

vertices = Union[Flatten[positiveEdges, 1], SameTest -> SameMatrix];

v3d = Map[projectToDirection[#, projectionMatrix]&, vertices];

svertices = SortBy[vertices, projectToDirection[#, projectionMatrix][[3]] + (Arg[projectToDirection[#, projectionMatrix][[1]] + I projectToDirection[#, projectionMatrix][[2]]] * 0.01)& ];
sv3d = Map[projectToDirection[#, projectionMatrix]&, svertices];
vnorm = Norm[svertices[[1]]];

polar = Map[{#, sv3d[[#,3]], Abs[sv3d[[#,1]] + I sv3d[[#,2]]], Arg[sv3d[[#,1]] + I sv3d[[#,2]]]/Pi}&, Table[k, {k, 1, Length[sv3d]}]];

svertices[[1]].svertices[[2]]/vnorm^2

(* threshold == 0.85, 3 layers of pentagons. 2, 9, 15, 21 on the same plane *)
{svertices[[2]], svertices[[9]], svertices[[15]], svertices[[21]]}//Det

a3=svertices[[21]]-svertices[[2]];
a1=svertices[[15]]-svertices[[9]];

(* 
Conjecture: 360 vertices of 3{4}5 are: 120 vertices from 600 cell.
Then take 120 edges and divide each by 3 parts, take the 240 dividing points.
*)
