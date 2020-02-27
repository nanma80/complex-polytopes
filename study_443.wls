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

cells24 ={{-Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}, {-2*Sqrt[3], 0, 0, 0}, {0, -2*Sqrt[3], 0, 0}, {0, 0, -2*Sqrt[3], 0}, {-Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {-Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {0, 0, 0, -2*Sqrt[3]}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {-Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {-Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {0, 0, 0, 2*Sqrt[3]}, {0, 0, 2*Sqrt[3], 0}, {-Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {0, 2*Sqrt[3], 0, 0}, {Sqrt[3], -Sqrt[3], Sqrt[3], -Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}, {Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {Sqrt[3], -Sqrt[3], -Sqrt[3], -Sqrt[3]}, {Sqrt[3], Sqrt[3], -Sqrt[3], -Sqrt[3]}, {Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {Sqrt[3], Sqrt[3], Sqrt[3], -Sqrt[3]}, {2*Sqrt[3], 0, 0, 0}};
faces24 ={{-3, -1, -1, -1}, {-2, -2, -2, 0}, {-2, -2, 0, -2}, {-3, -1, -1, 1}, {-3, -1, 1, -1}, {-3, -1, 1, 1}, {-2, -2, 2, 0}, {-1, -3, -1, -1}, {-1, -3, -1, 1}, {-1, -3, 1, 1}, {-1, -3, 1, -1}, {-1, -1, -3, -1}, {-1, -1, -3, 1}, {-1, 1, -3, 1}, {-2, 2, -2, 0}, {-1, 1, -3, -1}, {-3, 1, -1, -1}, {-2, 0, -2, -2}, {-3, 1, 1, -1}, {-2, 0, 2, -2}, {-2, 2, 0, -2}, {-1, -1, -1, -3}, {-1, -1, 1, -3}, {-1, 1, -1, -3}, {-1, 1, 1, -3}, {-2, -2, 0, 2}, {-3, 1, -1, 1}, {-2, 0, -2, 2}, {-3, 1, 1, 1}, {-2, 0, 2, 2}, {-1, -1, -1, 3}, {-1, -1, 1, 3}, {-1, 1, -1, 3}, {-1, 1, 1, 3}, {-2, 2, 0, 2}, {-2, 2, 2, 0}, {-1, -1, 3, -1}, {-1, -1, 3, 1}, {-1, 1, 3, 1}, {-1, 1, 3, -1}, {-1, 3, -1, -1}, {-1, 3, -1, 1}, {-1, 3, 1, 1}, {-1, 3, 1, -1}, {1, -1, -3, 1}, {1, -1, -3, -1}, {2, -2, -2, 0}, {0, -2, -2, -2}, {1, -3, -1, -1}, {0, -2, 2, -2}, {1, -3, 1, -1}, {1, -1, -1, -3}, {1, -1, 1, -3}, {2, -2, 0, -2}, {0, -2, -2, 2}, {1, -3, -1, 1}, {0, -2, 2, 2}, {1, -3, 1, 1}, {1, -1, -1, 3}, {1, -1, 1, 3}, {2, -2, 0, 2}, {1, -1, 3, 1}, {2, -2, 2, 0}, {1, -1, 3, -1}, {1, 1, -3, -1}, {0, 2, -2, -2}, {1, 1, -1, -3}, {2, 0, -2, -2}, {0, 2, -2, 2}, {1, 1, -3, 1}, {1, 1, -1, 3}, {2, 0, -2, 2}, {0, 2, 2, -2}, {1, 1, 3, -1}, {1, 1, 1, -3}, {2, 0, 2, -2}, {0, 2, 2, 2}, {1, 1, 1, 3}, {1, 1, 3, 1}, {2, 0, 2, 2}, {1, 3, -1, 1}, {2, 2, -2, 0}, {1, 3, -1, -1}, {1, 3, 1, -1}, {2, 2, 0, -2}, {2, 2, 0, 2}, {1, 3, 1, 1}, {2, 2, 2, 0}, {3, -1, -1, -1}, {3, -1, -1, 1}, {3, -1, 1, 1}, {3, -1, 1, -1}, {3, 1, -1, 1}, {3, 1, -1, -1}, {3, 1, 1, -1}, {3, 1, 1, 1}};


origin = {0, 0, 0, 2*Sqrt[3]};
neighbors1=Select[snappedEdges, Length[Intersection[#, {origin}, SameTest->SameMatrix]]>0&]


{
{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {2, 2, 0, 2}, {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}, {0, 0, 0, 2 Sqrt[3]}},
{{-1 + Sqrt[3], 0, -2, 1 + Sqrt[3]}, {0, 0, 0, 2 Sqrt[3]}, {1 - Sqrt[3], -2, 0, 1 + Sqrt[3]}, {0, -2, -2, 2}},
{{0, 0, 0, 2 Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {-2, 0, 2, 2}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}}
}


neighbors2=Select[snappedEdges, Length[Intersection[#, {neighbors1[[1,1]]}, SameTest->SameMatrix]]>0&]


{
{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {1, -1, 1, 3}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}},
{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {2, 2, 0, 2}, {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}, {0, 0, 0, 2 Sqrt[3]}},
{{Sqrt[3], Sqrt[3], -Sqrt[3], Sqrt[3]}, {2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {3, -1, -1, 1}, {1 + Sqrt[3], -1 + Sqrt[3], -2, 0}}
}

neighbors3=Select[snappedEdges, Length[Intersection[#, {neighbors2[[1,2]]}, SameTest->SameMatrix]]>0&]

{
{{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {1, -1, 1, 3}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}},
{{1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {1, -1, 1, 3}},
{{1, -1, 1, 3}, {0, 1 - Sqrt[3], 1 + Sqrt[3], 2}, {-Sqrt[3], -Sqrt[3], Sqrt[3], Sqrt[3]}, {1 - Sqrt[3], -2, 0, 1 + Sqrt[3]}}
}

neighbors4=Select[snappedEdges, Length[Intersection[#, {neighbors3[[2,3]]}, SameTest->SameMatrix]]>0&]

{
{{1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {1, -1, 1, 3}},
{{0, 0, 0, 2 Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {-2, 0, 2, 2}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}},
{{0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {1, 1, 3, 1}, {1 - Sqrt[3], 2, 1 + Sqrt[3], 0}, {-Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}}
}

(* edges that loops back *)

string = {
    {{0, 0, 0, 2 Sqrt[3]}, {2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {2, 2, 0, 2}, {0, 2, -1 + Sqrt[3], 1 + Sqrt[3]}},
    {{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}, {1, -1, 1, 3}, {-1 + Sqrt[3], -1 - Sqrt[3], 0, 2}, {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]}},
    {{1, -1, 1, 3}, {1 + Sqrt[3], 0, -1 + Sqrt[3], 2}, {Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}, {0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}},
    {{0, -1 + Sqrt[3], 2, 1 + Sqrt[3]}, {-2, 0, 2, 2}, {-2, 1 - Sqrt[3], 0, 1 + Sqrt[3]}, {0, 0, 0, 2 Sqrt[3]}}
}

Mean/@string//Simplify

                                    1 + Sqrt[3]  -1 - Sqrt[3]  1 - Sqrt[3]  3 + Sqrt[3]    1 + Sqrt[3]  -1 + Sqrt[3]  1 + Sqrt[3]  3 + Sqrt[3]
Out[130]= {{1, 1, 0, 1 + Sqrt[3]}, {-----------, ------------, -----------, -----------}, {-----------, ------------, -----------, -----------}, {-1, 0, 1, 1 + Sqrt[3]}}
                                         2            2             2            2              2            2             2            2

v12=Intersection[string[[1]], string[[2]]][[1]]
v23=Intersection[string[[2]], string[[3]]][[1]]
v34=Intersection[string[[3]], string[[4]]][[1]]
v41=Intersection[string[[4]], string[[1]]][[1]]


edgeIndex = 4;
edge1=string[[edgeIndex]];
center1=Mean[edge1]//Simplify;

knownDirections = Union[Map[#-center1&, edge1][[1;;2]], {center1}];

orth = {4, 3, 2, 1};
For[i=1,i<=Length[knownDirections],i++,
    dir = knownDirections[[i]];
    orth = orth - Dot[dir, orth]/Dot[dir, dir] * dir;
];
orth = orth/Norm[orth]*Norm[center1]//FullSimplify;
{center1, orth}

(* face1, after reschaling, center, and orth *)
{{1, 1, 0, 1 + Sqrt[3]}, {1, -1, 1 + Sqrt[3], 0}}

(* face2 *)
{{1, -1, -2 + Sqrt[3], Sqrt[3]}, {Sqrt[3], -2 + Sqrt[3], 1, -1}}

(* face3 *)
{{1, 2 - Sqrt[3], 1, Sqrt[3]}, {2 - Sqrt[3], -1, Sqrt[3], -1}}

(* face4 *)
{{-1, 0, 1, 1 + Sqrt[3]}, {-1, 1 + Sqrt[3], -1, 0}}

(* all orths are centers of other faces *)
Select[snappedEdges, Mean[#]=={1, 1, 0, 1 + Sqrt[3]}&]
Select[snappedEdges, Mean[#]=={1, -1, 1 + Sqrt[3], 0}&]
Select[snappedEdges, Mean[#]*(Sqrt[3]-1)=={1, -1, -2 + Sqrt[3], Sqrt[3]}&]
Select[snappedEdges, Mean[#]*(Sqrt[3]-1)=={Sqrt[3], -2 + Sqrt[3], 1, -1}&]
Select[snappedEdges, Mean[#]*(Sqrt[3]-1)=={2 - Sqrt[3], -1, Sqrt[3], -1}&]
Select[snappedEdges, Mean[#]=={-1, 1 + Sqrt[3], -1, 0}&]

cc1 = {0, 0, 0, 2 Sqrt[3]};
fc1 = {2, 2, 0, 2};
cc2 = {Sqrt[3], -Sqrt[3], -Sqrt[3], Sqrt[3]};
fc2 = {1, -1, 1, 3};
mid1 = (fc1 + cc1)/2//Simplify;
mid2 = (fc2 + cc2)/2//Simplify;

solution = Solve[ Dot[{x1,x2,x3,x4}-mid1, fc1-mid1] == 0
                && Dot[{x1,x2,x3,x4}-mid2, fc2-mid2] == 0
                && Dot[{x1,x2,x3,x4}, mid1] == Dot[cc1, mid1]
                && Dot[{x1,x2,x3,x4}, mid2] == Dot[cc2, mid2]
                , 
            {x1,x2,x3,x4}]
{x1,x2,x3,x4}/.solution//FullSimplify
=> {{2, 0, 1 - Sqrt[3], 1 + Sqrt[3]}}
This agrees with the coordinates above.

Intersection[snappedVertices, cells24]//Length 
(* 24, all cell centers are in snapped vertices *)


Intersection[snappedVertices, faces24]//Length 
(* 24, 24 out of 96 face centers are in snapped vertices *)

otherVertices = Complement[snappedVertices, faces24, cells24]
(* 48 complement *)

Select[snappedEdges, Length[Intersection[#, cells24]] > 0&]
(* 72. each CC (24) appears in 3 edges *)

Select[snappedEdges, Length[Intersection[#, faces24]] > 0&]
(* 72. each FC that appears in edges appears 3 times. Others appears 0 times *)


Select[snappedEdges, Length[Intersection[#, otherVertices]] > 0&]

Select[snappedEdges, Length[Intersection[#, {otherVertices[[1]]}]] > 0&]
(* each other vertex in edges appears 3 times *)

(* otherVertices must be a rotated version of 24 CC + 24 FC *)



epsilon = 0.00001;
SameMatrix[m1_, m2_] := ( m1 == m2 ) || (Max[Max[N[Abs[m1 - m2]]]] < epsilon);
Select[snappedEdges, Length[Intersection[#, {{Sqrt[3], Sqrt[3], Sqrt[3], Sqrt[3]}}, SameTest->SameMatrix]]>0&]

