#!/usr/bin/env wolframscript

symbols = { {2, 6, 4} };

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
maxNorm[direction_, realVertices_] := Max[Map[(#.direction)^2/direction.direction&, realVertices]];
getReal[complexVector_] := Flatten[ Map[{Re[#], Im[#]}&, complexVector] ];
doubleRotation[theta_] := ArrayFlatten[{
    {RotationMatrix[theta], 0},
    {0, RotationMatrix[theta]}
    }];

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
    {n11, n12}
];

getTriangularFaces[vertices_] := Module[
    {edgeLength, i, j, k},
    faces = {};
    edgeLength = 10^10;
    For[i = 2, i <= Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];
    Print["Triangular face edge length:"];
    Print[edgeLength];
    For[i = 1, i <= Length[vertices]-2, i++, 
        For[j = i + 1, j <= Length[vertices]-1, j++, 
            If[Abs[ Norm[vertices[[i]] - vertices[[j]]] - edgeLength] < epsilon,
                For[k = j + 1, k <= Length[vertices], k++,
                    If[Abs[ Norm[vertices[[i]] - vertices[[k]]] - edgeLength] < epsilon &&
                        Abs[ Norm[vertices[[j]] - vertices[[k]]] - edgeLength] < epsilon,
                        AppendTo[faces, {i, j, k}];
                    ];
                ];   
            ];
        ];
    ];
    faces
];

getSquareFaces[vertices_] := Module[
    {edgeLength, epsilon, i, j, k, l},
    faces = {};
    edgeLength = 10^10;
    epsilon = 0.0001;
    For[i = 2, i <= Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];
    Print["Square face edge length:"];
    Print[edgeLength];
    For[i = 1, i <= Length[vertices]-1, i++, 
        For[j = i + 1, j <= Length[vertices], j++, 
            If[Abs[ Norm[vertices[[i]] - vertices[[j]]] - edgeLength] < epsilon,
                For[k = 1, k <= Length[vertices], k++,
                    If[ Abs[ Norm[vertices[[j]] - vertices[[k]]] - edgeLength] < epsilon &&
                        Abs[ Norm[vertices[[i]] - vertices[[k]]] - Sqrt[2] * edgeLength] < epsilon,
                        For[l = 1, l <= Length[vertices], l++,
                            If[ Abs[ Norm[vertices[[k]] - vertices[[l]]] - edgeLength] < epsilon &&
                                Abs[ Norm[vertices[[l]] - vertices[[i]]] - edgeLength] < epsilon &&
                                Abs[ Norm[vertices[[l]] - vertices[[j]]] - Sqrt[2] * edgeLength] < epsilon,
                                    AppendTo[faces, {i, j, k, l}]
                            ];
                        ];
                    ];
                ];   
            ];
        ];
    ];
    faces
];

getEdgesFromFace[face_] := Table[{face[[i+1]], face[[Mod[i+1, Length[face]] + 1]]}, {i, 0, Length[face] - 1}];
sameCenter[edge1_, edge2_] := SameMatrix[Total[edge1], Total[edge2]];

dataFolder = "data";

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];

    p1 = symbol[[1]];
    q = symbol[[2]];
    p2 = symbol[[3]];

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];

    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];
    partitionFileName = FileNameJoin[{dataFolder, shapeFile <> "_partition.wl"}];

    If[!FileExistsQ[partitionFileName],
        dataObject = Get[dataFileName];

        complexVertices = dataObject[["vertices"]];
        complexEdges = dataObject[["edges"]];
        vertices = Map[getReal, complexVertices];
        edges = Map[getReal, complexEdges, {2}];

        Print["Partitioning vertices for "<> shape];

        vertices1 = {vertices[[1]]};
        vertices2 = {};

        For[iterationIndex = 1, iterationIndex < 100 && Length[vertices1] + Length[vertices2] < Length[vertices], iterationIndex++,
            incidentEdges = Select[edges, Length[Intersection[vertices1, #, SameTest -> SameMatrix]] > 0 &];
            vertices2 = Flatten[Map[Complement[#, vertices1, SameTest -> SameMatrix]&, incidentEdges], 1];
            vertices2 = Union[vertices2, SameTest -> SameMatrix];
            incidentEdges = Select[edges, Length[Intersection[vertices2, #, SameTest -> SameMatrix]] > 0 &];
            vertices1 = Flatten[Map[Complement[#, vertices2, SameTest -> SameMatrix]&, incidentEdges], 1];
            vertices1 = Union[vertices1, SameTest -> SameMatrix];
            Print[{iterationIndex, Length[vertices1], Length[vertices2]}];
        ];

        Print[{Length[vertices1], Length[vertices2]}];

        partitionDataObject = <|
            "vertices1" -> vertices1,
            "vertices2" -> vertices2
        |>;

        Save[partitionFileName, partitionDataObject];
        Print["Saved partitioned vertices to " <> partitionFileName];
    ];

    Print["Reading vertices for "<> shape];

    partitionFileName = FileNameJoin[{dataFolder, shapeFile <> "_partition.wl"}];

    partitionDataObject = Get[partitionFileName];
    vertices1 = partitionDataObject["vertices1"];
    vertices2 = partitionDataObject["vertices2"];

    (* how to get vertices2 from vertices1? Double rotation to move points
    along Hopf fibration circles *)
    vertex1 = vertices1[[1]];
    vertex2 = MaximalBy[ Map[{vertex1.#, #} &, vertices2], #[[1]]&][[1,2]];
    orth4d = Orthogonalize[{vertex1, vertex2, {0, 0.2, 1000, 0}, {0, 1.3, 0, -1000}}];
    theta = ArcCos[vertex2.vertex1/Norm[vertex1]/Norm[vertex2]];
    rot4d = Transpose[orth4d].doubleRotation[-theta].orth4d;

    ints = Intersection[vertices2, vertices1.rot4d, SameTest -> SameMatrix];
    Print["Lengths of vertices1, vertices2, and the intersection between vertices1 and its rotated version"];
    Print[Length/@{vertices1, vertices2, ints}];

    count = 0;
    For[index2 = 1, index2 <= Length[vertices2], index2++,
        Print[];
        vertex1 = vertices1[[1]];
        (* vertex2 = MaximalBy[ Map[{vertex1.#, #} &, vertices2], #[[1]]&][[1,2]]; *)
        (* vertex2 = SortBy[Map[{vertex1.#, #} &, vertices2], -#[[1]]&][[3,2]]; *)
        vertex2 = vertices2[[index2]];
        orth4d = Orthogonalize[{vertex1, vertex2, {0, 0.2, 1000, 0}, {0, 1.3, 0, -1000}}];
        theta = ArcCos[vertex2.vertex1/Norm[vertex1]/Norm[vertex2]];
        rot4d = Transpose[orth4d].doubleRotation[-theta].orth4d;

        ints = Intersection[vertices2, vertices1.rot4d, SameTest -> SameMatrix];
        (* Print["Lengths of vertices1, vertices2, and the intersection between vertices1 and its rotated version"]; *)

        orth4d = Orthogonalize[{vertex1, vertex2, {0, 1.3, 0, -1000}, {0, 0.2, 1000, 0}}];
        rot4d = Transpose[orth4d].doubleRotation[-theta].orth4d;

        ints2 = Intersection[vertices2, vertices1.rot4d, SameTest -> SameMatrix];
        (* Print["Lengths of vertices1, vertices2, and the intersection between vertices1 and its rotated version"]; *)
        Print[{index2, Length[ints], Length[ints2], theta/Pi*180}];
        If[Length[ints] == Length[vertices1] || Length[ints2] == Length[vertices1], count++];
    ];
    Print[count];

    norm = Norm[vertices1[[1]]];

    Print["Vertex counts:"];
    Print[{Length[vertices1], Length[vertices2]}];

    facesIndices1 = getTriangularFaces[vertices1];
    facesIndices2 = getTriangularFaces[vertices2];

    faces1 = Map[vertices1[[#]]&, facesIndices1, {2}];
    faces2 = Map[vertices2[[#]]&, facesIndices2, {2}];

    Print["Face counts:"];
    Print[{Length[faces1], Length[faces2]}];

    edges1 = Union[ Flatten[Map[getEdgesFromFace, faces1], 1], SameTest -> sameCenter];
    edges2 = Union[ Flatten[Map[getEdgesFromFace, faces2], 1], SameTest -> sameCenter];

    Print["Edge counts:"];
    Print[{Length[edges1], Length[edges2]}];

    squareFacesIndices1 = getSquareFaces[vertices1];
    squareFacesIndices2 = getSquareFaces[vertices2];
    squareFaces1 = Map[vertices1[[#]]&, squareFacesIndices1, {2}];
    squareFaces2 = Map[vertices2[[#]]&, squareFacesIndices2, {2}];

    faceCenters1 = Union[ Map[Total[#]/Length[#]&, squareFaces1], SameTest -> SameMatrix];
    faceCenters2 = Union[ Map[Total[#]/Length[#]&, squareFaces2], SameTest -> SameMatrix];

    faceCenters1 = faceCenters1/Norm[faceCenters1[[1]]] * norm;
    faceCenters2 = faceCenters2/Norm[faceCenters2[[1]]] * norm;

    Print["Unique face center counts:"];
    Print[{Length[faceCenters1], Length[faceCenters2]}];
    (* 24 for 2{6}4 *)

    vertices2AsFaceCenters1 = Intersection[vertices2, faceCenters1, SameTest -> SameMatrix];
    vertices1AsFaceCenters2 = Intersection[vertices1, faceCenters2, SameTest -> SameMatrix];

    Print["vertices as the face centers of the other group:"];
    Print[{Length[vertices2AsFaceCenters1], Length[vertices1AsFaceCenters2]}];
    (* 24 for 2{6}4 *)

    If[Length[vertices2AsFaceCenters1] == Length[vertices2] 
        && Length[vertices1AsFaceCenters2] == Length[vertices1],
        Print["All vertices are also face centers of the other group."],
        Print["Some vertices are not face centers"]];

];

