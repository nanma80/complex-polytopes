#!/usr/bin/env wolframscript

(* from any point on S3, if we rotate by rot4d, 
the trace of the point is a great circle. If we start from
many points, the great circles form the hopf fibration *)

point[sum_, diff_, theta_, eta_] := {
    Cos[sum + theta] Sin[eta],
    Sin[sum + theta] Sin[eta],
    Cos[diff + theta] Cos[eta],
    Sin[diff + theta] Cos[eta]
};

rot4d[theta_] := ArrayFlatten[{
    {RotationMatrix[theta], 0},
    {0, RotationMatrix[theta]}
    }];

seed[sum_, diff_, eta_] := {
    {Cos[sum] Sin[eta]},
    {Sin[sum] Sin[eta]},
    {Cos[diff] Cos[eta]},
    {Sin[diff] Cos[eta]}
};

Print[rot4d[theta].seed[sum, diff, eta] - point[sum, diff, theta, eta]//Simplify];

