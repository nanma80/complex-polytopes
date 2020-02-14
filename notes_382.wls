(* 382 old orientation

1.22475 = Sqrt[6]/2
3.67423 = 3 * Sqrt[6]/2
2.44949 = Sqrt[6]

72 vertices
 *)

vertices =
{{4 + Sqrt[6], 2 + Sqrt[6], 0, 0}, {2 + Sqrt[6], 3 + Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]},
 {2 + Sqrt[6], 3 + Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]}, {Sqrt[3/2], 3 + 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]},
 {3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, -1 - Sqrt[6]}, {1, 3 + Sqrt[6], 1, -3 - Sqrt[6]},
 {3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, 1 + Sqrt[6]}, {Sqrt[3/2], 3 + 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]},
 {1, 3 + Sqrt[6], 3 + Sqrt[6], 1}, {1, 3 + Sqrt[6], -3 - Sqrt[6], -1}, {2 + Sqrt[3/2], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2],
  Sqrt[3/2]}, {1, 3 + Sqrt[6], -1, 3 + Sqrt[6]}, {-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], 1 + Sqrt[6], 0},
 {3 + Sqrt[6], -1, 1, -3 - Sqrt[6]}, {3 + 3*Sqrt[3/2], -Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]},
 {-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], -1 - Sqrt[6], 0}, {Sqrt[3/2], 2 + Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]},
 {3 + Sqrt[6], -1, 3 + Sqrt[6], 1}, {1 + Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]},
 {3 + 3*Sqrt[3/2], -Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}, {0, 1 + Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]},
 {Sqrt[3/2], 2 + Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}, {2 + Sqrt[3/2], 1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]},
 {3 + Sqrt[6], -1, -3 - Sqrt[6], -1}, {2 + Sqrt[3/2], -Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]},
 {-2 - Sqrt[6], 4 + Sqrt[6], 0, 0}, {0, 1 + Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]},
 {-1 - Sqrt[3/2], 2 + Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {3 + Sqrt[6], -1, -1, 3 + Sqrt[6]},
 {0, 0, 4 + Sqrt[6], -2 - Sqrt[6]}, {1 + Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]},
 {3 + Sqrt[6], -2 - Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]}, {0, 0, -2 - Sqrt[6], -4 - Sqrt[6]},
 {-1 - Sqrt[3/2], 2 + Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-3 - Sqrt[6], 2 + Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]},
 {-2 - Sqrt[3/2], Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]}, {2 + Sqrt[3/2], -Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]},
 {3 + Sqrt[6], -2 - Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}, {1 + Sqrt[3/2], -2 - Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]},
 {-3 - Sqrt[6], 2 + Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}, {0, 0, 2 + Sqrt[6], 4 + Sqrt[6]},
 {-1 - Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]}, {0, 0, -4 - Sqrt[6], 2 + Sqrt[6]},
 {1 + Sqrt[3/2], -2 - Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-3 - Sqrt[6], 1, 1, -3 - Sqrt[6]},
 {2 + Sqrt[6], -4 - Sqrt[6], 0, 0}, {0, -1 - Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]},
 {-2 - Sqrt[3/2], Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]}, {-3 - Sqrt[6], 1, 3 + Sqrt[6], 1},
 {-Sqrt[3/2], -2 - Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], Sqrt[3/2]},
 {-3 - 3*Sqrt[3/2], Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]}, {-1 - Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]},
 {0, -1 - Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-3 - Sqrt[6], 1, -3 - Sqrt[6], -1},
 {-Sqrt[3/2], -2 - Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}, {1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], 1 + Sqrt[6], 0},
 {-3 - 3*Sqrt[3/2], Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}, {-3 - Sqrt[6], 1, -1, 3 + Sqrt[6]},
 {-1, -3 - Sqrt[6], 1, -3 - Sqrt[6]}, {1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -1 - Sqrt[6], 0},
 {-1, -3 - Sqrt[6], 3 + Sqrt[6], 1}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]},
 {-1, -3 - Sqrt[6], -3 - Sqrt[6], -1}, {-Sqrt[3/2], -3 - 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]},
 {-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, -1 - Sqrt[6]}, {-1, -3 - Sqrt[6], -1, 3 + Sqrt[6]},
 {-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, 1 + Sqrt[6]}, {-Sqrt[3/2], -3 - 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]},
 {-2 - Sqrt[6], -3 - Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]}, {-2 - Sqrt[6], -3 - Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]},
 {-4 - Sqrt[6], -2 - Sqrt[6], 0, 0}};

edges = 
{{{4 + Sqrt[6], 2 + Sqrt[6], 0, 0}, {3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, 1 + Sqrt[6]}, {2 + Sqrt[6], 3 + Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]}},
 {{2 + Sqrt[6], 3 + Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]}, {3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, -1 - Sqrt[6]}, {4 + Sqrt[6], 2 + Sqrt[6], 0, 0}},
 {{2 + Sqrt[6], 3 + Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]}, {Sqrt[3/2], 3 + 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]}, {1, 3 + Sqrt[6], 1, -3 - Sqrt[6]}},
 {{2 + Sqrt[6], 3 + Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]}, {1, 3 + Sqrt[6], -1, 3 + Sqrt[6]}, {Sqrt[3/2], 3 + 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]}},
 {{Sqrt[3/2], 3 + 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]}, {1, 3 + Sqrt[6], 3 + Sqrt[6], 1}, {-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], 1 + Sqrt[6], 0}},
 {{3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, -1 - Sqrt[6]}, {3 + Sqrt[6], -1, 1, -3 - Sqrt[6]}, {3 + 3*Sqrt[3/2], -Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]}},
 {{3 + 3*Sqrt[3/2], 1 + Sqrt[3/2], 0, 1 + Sqrt[6]}, {3 + 3*Sqrt[3/2], -Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}, {3 + Sqrt[6], -1, -1, 3 + Sqrt[6]}},
 {{1, 3 + Sqrt[6], 3 + Sqrt[6], 1}, {2 + Sqrt[3/2], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2], Sqrt[3/2]}, {Sqrt[3/2], 2 + Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]}},
 {{1, 3 + Sqrt[6], -3 - Sqrt[6], -1}, {Sqrt[3/2], 3 + 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]}, {-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], -1 - Sqrt[6], 0}},
 {{1, 3 + Sqrt[6], -3 - Sqrt[6], -1}, {Sqrt[3/2], 2 + Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}, {2 + Sqrt[3/2], 1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]}},
 {{1, 3 + Sqrt[6], -1, 3 + Sqrt[6]}, {0, 1 + Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-1 - Sqrt[3/2], 2 + Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}},
 {{-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], 1 + Sqrt[6], 0}, {-3 - Sqrt[6], 2 + Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]}, {-2 - Sqrt[6], 4 + Sqrt[6], 0, 0}},
 {{3 + 3*Sqrt[3/2], -Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]}, {3 + Sqrt[6], -2 - Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}, {3 + Sqrt[6], -1, -3 - Sqrt[6], -1}},
 {{3 + Sqrt[6], -1, 1, -3 - Sqrt[6]}, {2 + Sqrt[3/2], -Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]}, {1 + Sqrt[3/2], -2 - Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]}},
 {{-1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], -1 - Sqrt[6], 0}, {-2 - Sqrt[6], 4 + Sqrt[6], 0, 0}, {-3 - Sqrt[6], 2 + Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}},
 {{Sqrt[3/2], 2 + Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]}, {0, 0, 2 + Sqrt[6], 4 + Sqrt[6]}, {0, 1 + Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]}},
 {{3 + Sqrt[6], -1, 3 + Sqrt[6], 1}, {3 + Sqrt[6], -2 - Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]}, {3 + 3*Sqrt[3/2], -Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}},
 {{0, 1 + Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {1, 3 + Sqrt[6], 1, -3 - Sqrt[6]}, {-1 - Sqrt[3/2], 2 + Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]}},
 {{2 + Sqrt[3/2], 1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]}, {3 + Sqrt[6], -1, -3 - Sqrt[6], -1}, {1 + Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]}},
 {{0, 1 + Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {0, 0, -2 - Sqrt[6], -4 - Sqrt[6]}, {Sqrt[3/2], 2 + Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}},
 {{1 + Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]}, {3 + Sqrt[6], -1, 3 + Sqrt[6], 1}, {2 + Sqrt[3/2], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2], Sqrt[3/2]}},
 {{2 + Sqrt[3/2], -Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]}, {1 + Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]}, {0, 0, 4 + Sqrt[6], -2 - Sqrt[6]}},
 {{3 + Sqrt[6], -1, -1, 3 + Sqrt[6]}, {1 + Sqrt[3/2], -2 - Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {2 + Sqrt[3/2], -Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]}},
 {{-1 - Sqrt[3/2], 2 + Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {-2 - Sqrt[3/2], Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]}, {-3 - Sqrt[6], 1, 1, -3 - Sqrt[6]}},
 {{1 + Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]}, {2 + Sqrt[3/2], -Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]}, {0, 0, -4 - Sqrt[6], 2 + Sqrt[6]}},
 {{0, 0, 4 + Sqrt[6], -2 - Sqrt[6]}, {-1 - Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]}, {-2 - Sqrt[3/2], Sqrt[3/2], 2 + Sqrt[6], -3 - Sqrt[6]}},
 {{0, 0, -2 - Sqrt[6], -4 - Sqrt[6]}, {0, -1 - Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {-Sqrt[3/2], -2 - Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}},
 {{-3 - Sqrt[6], 2 + Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]}, {-3 - Sqrt[6], 1, 3 + Sqrt[6], 1}, {-3 - 3*Sqrt[3/2], Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}},
 {{3 + Sqrt[6], -2 - Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}, {2 + Sqrt[6], -4 - Sqrt[6], 0, 0}, {1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -1 - Sqrt[6], 0}},
 {{1 + Sqrt[3/2], -2 - Sqrt[3/2], Sqrt[3/2], -3 - 3*Sqrt[3/2]}, {-1, -3 - Sqrt[6], 1, -3 - Sqrt[6]}, {0, -1 - Sqrt[6], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2]}},
 {{0, 0, 2 + Sqrt[6], 4 + Sqrt[6]}, {-Sqrt[3/2], -2 - Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]}, {0, -1 - Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]}},
 {{-3 - Sqrt[6], 2 + Sqrt[6], -2 - Sqrt[3/2], -Sqrt[3/2]}, {-3 - 3*Sqrt[3/2], Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]}, {-3 - Sqrt[6], 1, -3 - Sqrt[6], -1}},
 {{0, 0, -4 - Sqrt[6], 2 + Sqrt[6]}, {-2 - Sqrt[3/2], Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]}, {-1 - Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]}},
 {{-1 - Sqrt[6], 0, 3 + 3*Sqrt[3/2], -1 - Sqrt[3/2]}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], Sqrt[3/2]}, {-3 - Sqrt[6], 1, 3 + Sqrt[6], 1}},
 {{1 + Sqrt[3/2], -2 - Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {0, -1 - Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-1, -3 - Sqrt[6], -1, 3 + Sqrt[6]}},
 {{-3 - Sqrt[6], 1, 1, -3 - Sqrt[6]}, {-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, -1 - Sqrt[6]}, {-3 - 3*Sqrt[3/2], Sqrt[3/2], -1 - Sqrt[3/2], -2 - Sqrt[3/2]}},
 {{2 + Sqrt[6], -4 - Sqrt[6], 0, 0}, {3 + Sqrt[6], -2 - Sqrt[6], 2 + Sqrt[3/2], Sqrt[3/2]}, {1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], 1 + Sqrt[6], 0}},
 {{-2 - Sqrt[3/2], Sqrt[3/2], -2 - Sqrt[6], 3 + Sqrt[6]}, {-1 - Sqrt[3/2], 2 + Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}, {-3 - Sqrt[6], 1, -1, 3 + Sqrt[6]}},
 {{-3 - Sqrt[6], 1, -3 - Sqrt[6], -1}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]}, {-1 - Sqrt[6], 0, -3 - 3*Sqrt[3/2], 1 + Sqrt[3/2]}},
 {{-Sqrt[3/2], -2 - Sqrt[3/2], -3 - Sqrt[6], -2 - Sqrt[6]}, {-1, -3 - Sqrt[6], -3 - Sqrt[6], -1}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], -3 - 3*Sqrt[3/2], -Sqrt[3/2]}},
 {{1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], 1 + Sqrt[6], 0}, {-1, -3 - Sqrt[6], 3 + Sqrt[6], 1}, {-Sqrt[3/2], -3 - 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]}},
 {{-3 - Sqrt[6], 1, -1, 3 + Sqrt[6]}, {-3 - 3*Sqrt[3/2], Sqrt[3/2], 1 + Sqrt[3/2], 2 + Sqrt[3/2]}, {-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, 1 + Sqrt[6]}},
 {{1 + Sqrt[3/2], -3 - 3*Sqrt[3/2], -1 - Sqrt[6], 0}, {-Sqrt[3/2], -3 - 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]}, {-1, -3 - Sqrt[6], -3 - Sqrt[6], -1}},
 {{-1, -3 - Sqrt[6], 1, -3 - Sqrt[6]}, {-Sqrt[3/2], -3 - 3*Sqrt[3/2], 2 + Sqrt[3/2], -1 - Sqrt[3/2]}, {-2 - Sqrt[6], -3 - Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]}},
 {{-1, -3 - Sqrt[6], 3 + Sqrt[6], 1}, {-Sqrt[3/2], -2 - Sqrt[3/2], 3 + Sqrt[6], 2 + Sqrt[6]}, {-2 - Sqrt[3/2], -1 - Sqrt[3/2], 3 + 3*Sqrt[3/2], Sqrt[3/2]}},
 {{-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, -1 - Sqrt[6]}, {-2 - Sqrt[6], -3 - Sqrt[6], Sqrt[3/2], -2 - Sqrt[3/2]}, {-4 - Sqrt[6], -2 - Sqrt[6], 0, 0}},
 {{-Sqrt[3/2], -3 - 3*Sqrt[3/2], -2 - Sqrt[3/2], 1 + Sqrt[3/2]}, {-1, -3 - Sqrt[6], -1, 3 + Sqrt[6]}, {-2 - Sqrt[6], -3 - Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]}},
 {{-4 - Sqrt[6], -2 - Sqrt[6], 0, 0}, {-2 - Sqrt[6], -3 - Sqrt[6], -Sqrt[3/2], 2 + Sqrt[3/2]}, {-3 - 3*Sqrt[3/2], -1 - Sqrt[3/2], 0, 1 + Sqrt[6]}}};


topEdge = 
    {{1, 3 + Sqrt[6], -1, 3 + Sqrt[6]}, {0, 1 + Sqrt[6], 1 + Sqrt[3/2], 3 + 3*Sqrt[3/2]},
    {-1 - Sqrt[3/2], 2 + Sqrt[3/2], -Sqrt[3/2], 3 + 3*Sqrt[3/2]}};

Total[topEdge]/3

solution = NSolve[ topEdge . Orthogonalize[{{a11, a12, a13, 1}, {2, a22, 3, a24}, {a31, a32, 4, a34}, {a41, 5, 6, 7}}] == 
 {{a, a, b, c}, {a, b, a, c}, {b, a, a, c}}, {a11, a12, a13, a22, a24, a31, a32, a34, a41, a, b, c}]

Map[N[Norm[#]]&, vertices]

rotMat = {
    {1, 1, 0, 0}, 
    {-1, 1, 0, 0}, 
    {0, 0, 1, 1}, 
    {0, 0, -1, 1}
};

rotMat = {
    {1, 0, 1, 0}, 
    {0, 1, 0, 1}, 
    {-1, 0, 1, 0}, 
    {0, -1, 0, 1}
};

Map[Abs[#]&, Flatten[vertices . rotMat]]//Union//Length
