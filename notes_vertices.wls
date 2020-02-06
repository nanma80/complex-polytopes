3{8}2:

72 vertices. Bitruncated 24-cell?
1.22475 = Sqrt[6]/2
3.67423 = 3 * Sqrt[6]/2
2.44949 = Sqrt[6]


uniform bitruncated 24-cell: 6 values. all perms and signs of
(0, 2+√2, 2+√2, 2+2√2)
(1, 1+√2, 1+√2, 3+2√2)

3{6}2:

a = sqrt(1+sqrt(3)/2)=1.36602540378

{a, a, 0, 1},
{a, 0, 1, a},
{a, 1, a, 0},

{a, -a, -1, 0},
{a, -1, 0, -a},
{a, 0, -a, -1},

{1, -a, 0, a},
{0, -a, -a, 1},

{0, -1, a, a},
{-a, -1, -a, 0},
{-1, 0, -a, a},
{0, -a, 1, -a},

{-1, -a, a, 0},
{1, a, -a, 0},
{-a, -a, 0, -1},
{0, a, -1, a},
{1, 0, a, -a},
{0, 1, -a, -a},
{-a, 0, a, 1},
{-a, 0, -1, -a},
{-a, 1, 0, a},
{0, a, a, -1},
{-1, a, 0, -a},
{-a, a, 1, 0}

similar to
https://en.wikipedia.org/wiki/Truncated_tesseract#Bitruncated_tesseract
http://eusebeia.dyndns.org/4d/bitrunc8cell

it has 96 vertices. The exact ratio between the coordinates are not the same.

Why this a? Projection has [12] symmetry. Other reasons?


a = Sqrt[1+Sqrt[3]/2];
vertices = {{a, a, 0, 1},{a, 0, 1, a},{a, 1, a, 0}};
face[u_, v_] := vertices[[1]] + u (vertices[[2]]-vertices[[1]]) + v (vertices[[3]]-vertices[[1]]);

cc16={(2 a + 1)/4, (2 a + 1)/4, (2 a + 1)/4, (2 a + 1)/4};
cc8={a,0,0,0};
fc={a, (a+1)/3, (a+1)/3,(a+1)/3};

solution16 = Minimize[Norm[face[u, v] - cc16]^2, {u, v}];
solution8 = Minimize[Norm[face[u, v] - cc8]^2, {u, v}];
solutionfc = Minimize[Norm[face[u, v] - fc]^2, {u, v}];
Print[{Norm[cc16-fc], Norm[cc8-fc]}//N];

(* cannot find any reason *)
