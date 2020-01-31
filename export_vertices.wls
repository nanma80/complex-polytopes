#!/usr/bin/env wolframscript

symbols = {
    (* {3, 3, 3} *)
    (* , {3, 5, 3} *)
	(* {4, 4, 2} *)
    (* , {3, 4, 3} *)
    (* {5, 4, 2} *)
    (* , {2, 4, 5} *)
    (* {3, 6, 2} *)
    (* {4, 6, 2} *)
    (* {4, 4, 3} *)
    (* {3, 4, 4} *)
    (* , {3, 3, 2} *)
    (* , {3, 5/2, 3} *)
    (* {5, 3, 2} *)
    (* {5, 6, 2} *)
    (* {5, 4, 3} *)
    {3, 4, 5}
};

symbol = symbols[[1]];

exportToPov = True;
dataFolder = "data";
imageFolder = "output";

getQString[q_, separator_] := If[IntegerQ[q], IntegerString[q], IntegerString[Numerator[q]] <> separator <> IntegerString[Denominator[q]]];
getFileName[symbol_] := "complex_polytope_" <> IntegerString[symbol[[1]]] <> "_" <> getQString[symbol[[2]], "over"] <> "_" <> IntegerString[symbol[[3]]];
getShapeName[symbol_] := IntegerString[symbol[[1]]] <> "{" <> getQString[symbol[[2]], "/"] <> "}" <> IntegerString[symbol[[3]]];

dataFolder = "data";

shape = getShapeName[symbol];
shapeFile = getFileName[symbol];

dataFileName = FileNameJoin[{dataFolder, shapeFile <> ".wl"}];

dataObject = Get[dataFileName];

realVertices = dataObject[["rotatedRealVertices"]];
Print["4OFF"];
Print["# Vertices for " <> shape <> " , 4D real representation"];

Print[Length[realVertices]];
Print[];
Print["# Vertices.  Each line is the XYZW coordinates of one vertex."];

For[i = 1, i<= Length[realVertices], i++,
    vertex = realVertices[[i]];
    str = "";
    For[j = 1, j <= 4, j++,
        str = str <> ToString[DecimalForm[vertex[[j]], 100]];
        If[j < 4,
            str = str <> " ";
        ];
    ];
    Print[str];
];

