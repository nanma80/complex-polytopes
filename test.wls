#!/usr/bin/env wolframscript

symbols = {
    (* {3, 3, 3} *)
    (* , {3, 5, 3} *)
	(* {4, 4, 2} *)
    (* , {3, 4, 3} *)
    {5, 4, 2}
    (* , {2, 4, 5} *)
    (* {3, 6, 2} *)
    (* , {3, 3, 2} *)
    (* , {3, 5/2, 3} *)
    (* {5, 3, 2} *)
    (* , {5, 6, 2} *)
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

(* realVertices = dataObject[["rotatedRealVertices"]];
realEdges = dataObject[["rotatedRealEdges"]];
 *)



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
