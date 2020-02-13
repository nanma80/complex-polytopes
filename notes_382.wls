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


Map[N[Norm[#]]&, vertices]
