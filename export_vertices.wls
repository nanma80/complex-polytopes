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

(* symbols = { {3, 8, 2} }; *)

exportToPov = True;
dataFolder = "data";
imageFolder = "output";

getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];

dataFolder = "data";

For[symbolIndex = 1, symbolIndex <= Length[symbols], symbolIndex++,
    symbol = symbols[[symbolIndex]];

    shape = getShapeName[symbol];
    shapeFile = getFileName[symbol];

    dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

    dataObject = Get[dataFileName];

    vertexFileName = FileNameJoin[{dataFolder, shapeFile <> "_vertices.txt"}];
    Print[vertexFileName];

    realVertices = dataObject[["rotatedRealVertices"]];
    outputString = {
        "4OFF",
        "# Vertices for " <> shape <> " , 4D real representation",
        IntegerString[Length[realVertices]],
        "",
        "# Vertices.  Each line is the XYZW coordinates of one vertex."
    };

    For[i = 1, i<= Length[realVertices], i++,
        vertex = realVertices[[i]];
        str = "";
        For[j = 1, j <= 4, j++,
            str = str <> ToString[DecimalForm[vertex[[j]], 100]];
            If[j < 4,
                str = str <> " ";
            ];
        ];
        AppendTo[outputString, str];
    ];

    Export[vertexFileName, outputString];
];
