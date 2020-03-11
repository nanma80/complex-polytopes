#!/usr/bin/env wolframscript

epsilon = 0.0000001;
getEdges[vertices_] := Module[
    {edgeLength, i, j},
    edges = {};
    edgeLength = 10^10;
    For[i = 2, i < Length[vertices], i++, 
        If[ Norm[vertices[[i]] - vertices[[1]]] < edgeLength, edgeLength = Norm[vertices[[i]] - vertices[[1]]]];
    ];

    For[i = 1, i <= Length[vertices]-1, i++, 
        For[j = i + 1, j <= Length[vertices], j++, 
            If[ Abs[Norm[vertices[[i]] - vertices[[j]]] - edgeLength] < epsilon, AppendTo[edges, {i, j}] ];   
        ];
    ];
    edges
];

SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);

(* following the script of rotate_263.wls *)
(* snappedEdges are for 443 *)
snappedEdges =
{{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {1, -1, 1, 3}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}},
 {{1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {2, -1 - Sqrt[3], 0, -1 + Sqrt[3]}, {3, -1, -1, 1}},
 {{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {2, 2, 0, 2}, {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}, {0, 0, 0, 2*Sqrt[3]}},
 {{1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {1, -1, 1, 3}},
 {{2, 2, 0, 2}, {2, 1 + Sqrt[3], -1 + Sqrt[3], 0}, {0, 2*Sqrt[3], 0, 0}, {0, 1 + Sqrt[3], 1 - Sqrt[3], 2}},
 {{1, -1, 1, 3}, {0, 1 - Sqrt[3], 1 + Sqrt[3], 2}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {1 - Sqrt[3], -2, 0, 1 + Sqrt[3]}},
 {{3, -1, -1, 1}, {1 + Sqrt[3], -2, 0, 1 - Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}, {2, 1 - Sqrt[3], -1 - Sqrt[3], 0}},
 {{Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {1 + Sqrt[3], 2, 1 - Sqrt[3], 0}, {1, 3, -1, -1}, {0, 1 + Sqrt[3], -2, -1 + Sqrt[3]}},
 {{Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {0, 1 + Sqrt[3], 1 - Sqrt[3], 2}, {-1, 1, -1, 3}, {-1 + Sqrt[3], 0, -2, 1 + Sqrt[3]}},
 {{Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {-1 + Sqrt[3], 1 + Sqrt[3], 2, 0}, {-1, 3, 1, 1}, {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}},
 {{Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {3, -1, -1, 1}, {1 + Sqrt[3], -1 + Sqrt[3], -2, 0}},
 {{1 + Sqrt[3], 0, 2, -1 + Sqrt[3]}, {1, 1, 3, 1}, {0, 1 - Sqrt[3], 1 + Sqrt[3], 2}, {Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}},
 {{-1 + Sqrt[3], 0, -2, 1 + Sqrt[3]}, {0, 0, 0, 2*Sqrt[3]}, {1 - Sqrt[3], -2, 0, 1 + Sqrt[3]}, {0, -2, -2, 2}},
 {{2*Sqrt[3], 0, 0, 0}, {1 + Sqrt[3], 0, 2, -1 + Sqrt[3]}, {2, -2, 2, 0}, {1 + Sqrt[3], -2, 0, 1 - Sqrt[3]}},
 {{2*Sqrt[3], 0, 0, 0}, {1 + Sqrt[3], 2, 1 - Sqrt[3], 0}, {2, 2, 0, 2}, {1 + Sqrt[3], 0, -1 + Sqrt[3], 2}},
 {{0, 0, 0, 2*Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {-2, 0, 2, 2}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}},
 {{Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {0, -2, 1 + Sqrt[3], -1 + Sqrt[3]}, {-1, -3, 1, 1}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}},
 {{Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {2, -1 - Sqrt[3], 0, -1 + Sqrt[3]}, {1, -3, -1, -1},
  {-1 + Sqrt[3], -2, -1 - Sqrt[3], 0}}, {{1 + Sqrt[3], 2, 1 - Sqrt[3], 0}, {3, 1, 1, -1}, {2, -1 + Sqrt[3], 0, -1 - Sqrt[3]},
  {Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}}, {{0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}, {-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]},
  {-1 - Sqrt[3], -1 + Sqrt[3], 0, 2}, {-1, 1, -1, 3}}, {{1 + Sqrt[3], -1 + Sqrt[3], -2, 0}, {Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, 
  {0, 2, -1 - Sqrt[3], 1 - Sqrt[3]}, {1, 1, -3, 1}}, {{1 + Sqrt[3], -1 + Sqrt[3], -2, 0}, {2*Sqrt[3], 0, 0, 0},
  {1 + Sqrt[3], 1 - Sqrt[3], 0, -2}, {2, 0, -2, -2}}, {{0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {1, 1, 3, 1},
  {1 - Sqrt[3], 2, 1 + Sqrt[3], 0}, {-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}}, {{2, -1 - Sqrt[3], 0, -1 + Sqrt[3]}, {2, -2, 2, 0},
  {0, -1 - Sqrt[3], 2, 1 - Sqrt[3]}, {0, -2*Sqrt[3], 0, 0}}, {{0, 1 + Sqrt[3], 1 - Sqrt[3], 2}, {-1, 3, 1, 1},
  {-1 - Sqrt[3], 2, 0, -1 + Sqrt[3]}, {-Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}},
 {{2, 1 + Sqrt[3], -1 + Sqrt[3], 0}, {Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {-1 + Sqrt[3], 2, 0, -1 - Sqrt[3]}, {1, 3, -1, -1}},
 {{2, 1 + Sqrt[3], -1 + Sqrt[3], 0}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {1 + Sqrt[3], 0, 2, -1 + Sqrt[3]}, {3, 1, 1, -1}},
 {{3, 1, 1, -1}, {2, 0, 1 + Sqrt[3], 1 - Sqrt[3]}, {Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {1 + Sqrt[3], 1 - Sqrt[3], 0, -2}},
 {{1, 1, -3, 1}, {-1 + Sqrt[3], 0, -2, 1 + Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {2, 1 - Sqrt[3], -1 - Sqrt[3], 0}},
 {{-1, 1, -1, 3}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {1 - Sqrt[3], 0, -1 - Sqrt[3], 2}},
 {{1, 1, -3, 1}, {0, 1 + Sqrt[3], -2, -1 + Sqrt[3]}, {-Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {1 - Sqrt[3], 0, -1 - Sqrt[3], 2}},
 {{2, 1 - Sqrt[3], -1 - Sqrt[3], 0}, {2, 0, -2, -2}, {0, -1 + Sqrt[3], -1 - Sqrt[3], -2}, {0, 0, -2*Sqrt[3], 0}},
 {{0, 1 - Sqrt[3], 1 + Sqrt[3], 2}, {0, 0, 2*Sqrt[3], 0}, {-2, -1 + Sqrt[3], 1 + Sqrt[3], 0}, {-2, 0, 2, 2}},
 {{1 + Sqrt[3], -2, 0, 1 - Sqrt[3]}, {Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {0, -1 - Sqrt[3], -1 + Sqrt[3], -2}, {1, -3, -1, -1}}, 
 {{1 - Sqrt[3], -2, 0, 1 + Sqrt[3]}, {-1, -3, 1, 1}, {-2, -1 - Sqrt[3], 1 - Sqrt[3], 0}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}},
 {{0, -2, -2, 2}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {0, -2*Sqrt[3], 0, 0}, {1 - Sqrt[3], -1 - Sqrt[3], -2, 0}},
 {{2, 0, 1 + Sqrt[3], 1 - Sqrt[3]}, {0, 0, 2*Sqrt[3], 0}, {0, -2, 1 + Sqrt[3], -1 + Sqrt[3]}, {2, -2, 2, 0}},
 {{0, 1 + Sqrt[3], -2, -1 + Sqrt[3]}, {0, 2*Sqrt[3], 0, 0}, {-2, 1 + Sqrt[3], 0, 1 - Sqrt[3]}, {-2, 2, -2, 0}},
 {{-1 + Sqrt[3], 1 + Sqrt[3], 2, 0}, {1, 1, 3, 1}, {2, 0, 1 + Sqrt[3], 1 - Sqrt[3]}, {Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}},
 {{1 + Sqrt[3], 1 - Sqrt[3], 0, -2}, {1, -1, 1, -3}, {0, -2, 1 - Sqrt[3], -1 - Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}},
 {{-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {-1 - Sqrt[3], -2, -1 + Sqrt[3], 0}, {-3, -1, -1, 1}}, 
 {{-1 + Sqrt[3], -2, -1 - Sqrt[3], 0}, {0, 0, -2*Sqrt[3], 0}, {1 - Sqrt[3], 0, -1 - Sqrt[3], 2}, {0, -2, -2, 2}},
 {{0, -2, 1 + Sqrt[3], -1 + Sqrt[3]}, {-1, -1, 3, -1}, {-1 - Sqrt[3], 1 - Sqrt[3], 2, 0}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}},
 {{-1 + Sqrt[3], -2, -1 - Sqrt[3], 0}, {Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}, {0, 1 - Sqrt[3], -2, -1 - Sqrt[3]},
  {-1, -1, -3, -1}}, {{0, 2*Sqrt[3], 0, 0}, {-1 + Sqrt[3], 1 + Sqrt[3], 2, 0}, {0, 2, 2, -2}, {1 - Sqrt[3], 1 + Sqrt[3], 0, -2}},
 {{1, 3, -1, -1}, {1 - Sqrt[3], 1 + Sqrt[3], 0, -2}, {-Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {0, 2, -1 - Sqrt[3], 1 - Sqrt[3]}},
 {{-1, 3, 1, 1}, {1 - Sqrt[3], 2, 1 + Sqrt[3], 0}, {-Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {-2, 1 + Sqrt[3], 0, 1 - Sqrt[3]}},
 {{Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {-1 + Sqrt[3], 2, 0, -1 - Sqrt[3]}, {-1, 1, -1, -3},
  {0, -1 + Sqrt[3], -1 - Sqrt[3], -2}}, {{-Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {-1 - Sqrt[3], -1 + Sqrt[3], 0, 2},
  {-3, -1, -1, 1}, {-2, 0, -1 - Sqrt[3], -1 + Sqrt[3]}}, {{Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]},
  {-1 + Sqrt[3], 0, 1 + Sqrt[3], -2}, {1, -1, 1, -3}, {2, -1 + Sqrt[3], 0, -1 - Sqrt[3]}},
 {{-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {-2, -1 + Sqrt[3], 1 + Sqrt[3], 0}, {-3, 1, 1, -1}, {-1 - Sqrt[3], 2, 0, -1 + Sqrt[3]}},
 {{2, 0, -2, -2}, {2, -1 + Sqrt[3], 0, -1 - Sqrt[3]}, {0, 0, 0, -2*Sqrt[3]}, {0, 1 - Sqrt[3], -2, -1 - Sqrt[3]}},
 {{0, 0, -2*Sqrt[3], 0}, {0, 2, -1 - Sqrt[3], 1 - Sqrt[3]}, {-2, 2, -2, 0}, {-2, 0, -1 - Sqrt[3], -1 + Sqrt[3]}},
 {{Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {-1 + Sqrt[3], 0, 1 + Sqrt[3], -2}, {-1, -1, 3, -1}, {0, -1 - Sqrt[3], 2, 1 - Sqrt[3]}},
 {{1, -3, -1, -1}, {0, -2, 1 - Sqrt[3], -1 - Sqrt[3]}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]},
  {1 - Sqrt[3], -1 - Sqrt[3], -2, 0}}, {{-1, -3, 1, 1}, {0, -1 - Sqrt[3], 2, 1 - Sqrt[3]}, {-Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, 
  {-1 - Sqrt[3], -2, -1 + Sqrt[3], 0}}, {{0, -2*Sqrt[3], 0, 0}, {0, -1 - Sqrt[3], -1 + Sqrt[3], -2}, {-2, -2, 0, -2},
  {-2, -1 - Sqrt[3], 1 - Sqrt[3], 0}}, {{1 - Sqrt[3], 2, 1 + Sqrt[3], 0}, {0, 0, 2*Sqrt[3], 0}, {-1 + Sqrt[3], 0, 1 + Sqrt[3], -2}, 
  {0, 2, 2, -2}}, {{-1 - Sqrt[3], -1 + Sqrt[3], 0, 2}, {-2, 0, 2, 2}, {-1 - Sqrt[3], 1 - Sqrt[3], 2, 0}, {-2*Sqrt[3], 0, 0, 0}},
 {{-2, 0, -1 - Sqrt[3], -1 + Sqrt[3]}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {1 - Sqrt[3], -1 - Sqrt[3], -2, 0},
  {-1, -1, -3, -1}}, {{-1 + Sqrt[3], 2, 0, -1 - Sqrt[3]}, {0, 2, 2, -2}, {1 - Sqrt[3], 0, 2, -1 - Sqrt[3]}, {0, 0, 0, -2*Sqrt[3]}}, 
 {{-2, 2, -2, 0}, {-1 - Sqrt[3], 2, 0, -1 + Sqrt[3]}, {-2*Sqrt[3], 0, 0, 0}, {-1 - Sqrt[3], 0, -2, 1 - Sqrt[3]}},
 {{0, -1 + Sqrt[3], -1 - Sqrt[3], -2}, {-Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {-1 - Sqrt[3], 0, -2, 1 - Sqrt[3]},
  {-1, -1, -3, -1}}, {{1, -1, 1, -3}, {1 - Sqrt[3], 0, 2, -1 - Sqrt[3]}, {-Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]},
  {0, -1 - Sqrt[3], -1 + Sqrt[3], -2}}, {{-2, 1 + Sqrt[3], 0, 1 - Sqrt[3]}, {-3, 1, 1, -1}, {-1 - Sqrt[3], 0, 1 - Sqrt[3], -2},
  {-Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}}, {{1 - Sqrt[3], 1 + Sqrt[3], 0, -2}, {-Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]},
  {-2, 0, -1 + Sqrt[3], -1 - Sqrt[3]}, {-1, 1, -1, -3}}, {{0, 1 - Sqrt[3], -2, -1 - Sqrt[3]}, {-1, 1, -1, -3},
  {-1 - Sqrt[3], 0, 1 - Sqrt[3], -2}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}},
 {{0, -2, 1 - Sqrt[3], -1 - Sqrt[3]}, {0, 0, 0, -2*Sqrt[3]}, {-2, 0, -1 + Sqrt[3], -1 - Sqrt[3]}, {-2, -2, 0, -2}},
 {{-Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {-2, -1 + Sqrt[3], 1 + Sqrt[3], 0}, {-1, -1, 3, -1}, {1 - Sqrt[3], 0, 2, -1 - Sqrt[3]}},
 {{-1 - Sqrt[3], 0, -2, 1 - Sqrt[3]}, {-3, -1, -1, 1}, {-2, -1 - Sqrt[3], 1 - Sqrt[3], 0},
  {-Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}}, {{-3, 1, 1, -1}, {-1 - Sqrt[3], 1 - Sqrt[3], 2, 0},
  {-Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {-2, 0, -1 + Sqrt[3], -1 - Sqrt[3]}},
 {{-1 - Sqrt[3], 0, 1 - Sqrt[3], -2}, {-2*Sqrt[3], 0, 0, 0}, {-1 - Sqrt[3], -2, -1 + Sqrt[3], 0}, {-2, -2, 0, -2}}};

snappedVertices =
{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {2, 2, 0, 2}, {1, -1, 1, 3}, {3, -1, -1, 1},
 {Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {2*Sqrt[3], 0, 0, 0},
 {1 + Sqrt[3], 0, 2, -1 + Sqrt[3]}, {-1 + Sqrt[3], 0, -2, 1 + Sqrt[3]}, {0, 0, 0, 2*Sqrt[3]},
 {Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {1 + Sqrt[3], 2, 1 - Sqrt[3], 0},
 {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}, {1 + Sqrt[3], -1 + Sqrt[3], -2, 0}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]},
 {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {2, -1 - Sqrt[3], 0, -1 + Sqrt[3]}, {0, 1 + Sqrt[3], 1 - Sqrt[3], 2},
 {2, 1 + Sqrt[3], -1 + Sqrt[3], 0}, {3, 1, 1, -1}, {1, 1, -3, 1}, {-1, 1, -1, 3}, {1, 1, 3, 1}, {2, 1 - Sqrt[3], -1 - Sqrt[3], 0},
 {0, 1 - Sqrt[3], 1 + Sqrt[3], 2}, {1 + Sqrt[3], -2, 0, 1 - Sqrt[3]}, {2, -2, 2, 0}, {1 - Sqrt[3], -2, 0, 1 + Sqrt[3]},
 {0, -2, -2, 2}, {2, 0, 1 + Sqrt[3], 1 - Sqrt[3]}, {1 - Sqrt[3], 0, -1 - Sqrt[3], 2}, {0, 1 + Sqrt[3], -2, -1 + Sqrt[3]},
 {-1 + Sqrt[3], 1 + Sqrt[3], 2, 0}, {1 + Sqrt[3], 1 - Sqrt[3], 0, -2}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]},
 {0, -2, 1 + Sqrt[3], -1 + Sqrt[3]}, {-1 + Sqrt[3], -2, -1 - Sqrt[3], 0}, {0, 2*Sqrt[3], 0, 0}, {-1, 3, 1, 1}, {1, 3, -1, -1},
 {Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {-Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]},
 {-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {2, 0, -2, -2}, {0, 0, 2*Sqrt[3], 0}, {-2, 0, 2, 2}, {0, 0, -2*Sqrt[3], 0},
 {Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}, {Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]},
 {-Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {1, -3, -1, -1}, {-1, -3, 1, 1}, {0, -2*Sqrt[3], 0, 0}, {1 - Sqrt[3], 2, 1 + Sqrt[3], 0}, 
 {0, 2, -1 - Sqrt[3], 1 - Sqrt[3]}, {2, -1 + Sqrt[3], 0, -1 - Sqrt[3]}, {-1 - Sqrt[3], -1 + Sqrt[3], 0, 2},
 {0, -1 - Sqrt[3], 2, 1 - Sqrt[3]}, {1 - Sqrt[3], -1 - Sqrt[3], -2, 0}, {-1 + Sqrt[3], 0, 1 + Sqrt[3], -2},
 {-2, 0, -1 - Sqrt[3], -1 + Sqrt[3]}, {-1 + Sqrt[3], 2, 0, -1 - Sqrt[3]}, {-1 - Sqrt[3], 2, 0, -1 + Sqrt[3]}, {0, 2, 2, -2},
 {-2, 2, -2, 0}, {0, -1 + Sqrt[3], -1 - Sqrt[3], -2}, {-2, -1 + Sqrt[3], 1 + Sqrt[3], 0}, {1, -1, 1, -3}, {-1, -1, 3, -1},
 {-3, -1, -1, 1}, {-1, -1, -3, -1}, {0, -1 - Sqrt[3], -1 + Sqrt[3], -2}, {-2, -1 - Sqrt[3], 1 - Sqrt[3], 0},
 {1 - Sqrt[3], 1 + Sqrt[3], 0, -2}, {-2, 1 + Sqrt[3], 0, 1 - Sqrt[3]}, {-1 - Sqrt[3], 1 - Sqrt[3], 2, 0},
 {0, 1 - Sqrt[3], -2, -1 - Sqrt[3]}, {0, -2, 1 - Sqrt[3], -1 - Sqrt[3]}, {-1 - Sqrt[3], -2, -1 + Sqrt[3], 0},
 {-Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {-Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {1 - Sqrt[3], 0, 2, -1 - Sqrt[3]},
 {0, 0, 0, -2*Sqrt[3]}, {-2*Sqrt[3], 0, 0, 0}, {-1 - Sqrt[3], 0, -2, 1 - Sqrt[3]}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]},
 {-Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {-3, 1, 1, -1}, {-1, 1, -1, -3}, {-2, -2, 0, -2}, {-1 - Sqrt[3], 0, 1 - Sqrt[3], -2},
 {-2, 0, -1 + Sqrt[3], -1 - Sqrt[3]}};

nearestNeighborEdges = {};

edgeIndices = getEdges[snappedVertices];
Print["Number of nearest neighbor edges: " <> IntegerString[Length[edgeIndices]]];
edges = Map[snappedVertices[[#]]&, edgeIndices, {2}];
verticesInEdges = Union[Flatten[edges, 1]];

Print[verticesInEdges//Length]; (* 96 *)
Print[snappedVertices//Length]; (* 96 *)
Print[edgeIndices//Length]; (* 96 *)

components = ConnectedComponents[Graph[edgeIndices]];
Print[components//Length]; (* 8 *)
Print[Length/@components]; (* 12 *)

dataFolder = "data";
polytopeFileName = FileNameJoin[{dataFolder, "polytope_3_4_3_alt.wl"}];
polytopeData = Get[polytopeFileName];
polytopeEdges = polytopeData["edges"];
polytopeVertices = polytopeData["vertices"];
polytopeFaces = polytopeData["faces"];
polytopeCells = polytopeData["cells"];

targetNorm = snappedVertices[[1]]//Norm//Simplify;
polytopeVertices = polytopeVertices / Norm[polytopeVertices[[1]]] * targetNorm//Simplify;
edgeCenters = Map[Total, polytopeEdges];
edgeCenters = edgeCenters / Norm[edgeCenters[[1]]] * targetNorm//Simplify;

(* Print["edge centers"]; *)
(* Print[edgeCenters]; *)
(* {3, 1, 1, 1}, normalized, plus minus, permutate *)
(* {0, 2, 2, 2}, normalized, plus minus, permutate *)

faceCenters = Map[Total, polytopeFaces];
faceCenters = faceCenters / Norm[faceCenters[[1]]] * targetNorm//Simplify;
(* Print["face centers"]; *)
(* Print[faceCenters]; *)
(* {2, 1, 1, 0}, normalized, plus minus, permutate *)

Print[Intersection[N[polytopeVertices], snappedVertices, SameTest -> SameMatrix]//Length];


verticesInComps = {};
For[compIndex = 1, compIndex <= Length[components], compIndex++,
  component = components[[compIndex]];
  verticesInComp = Map[snappedVertices[[#]]&, component];

  Print[Intersection[N[polytopeVertices], verticesInComp, SameTest -> SameMatrix]//Length];
  Print[verticesInComp];

  AppendTo[verticesInComps, verticesInComp];
];


(* 

8 great circles altogether. Each circle has 12 points.
4 great circles have 6 24-vertices each. The other points are edge centers.
The other 4 don't have 24-vertices. How to describe them?

*)