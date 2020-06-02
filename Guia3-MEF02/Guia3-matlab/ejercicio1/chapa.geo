cl1 = 3;
cl2 = 3;
Point(1) = {0, 0, 0, cl1};
Point(2) = {0, 10, 0, cl1};
Point(3) = {20, 10, 0, cl2};
Point(4) = {20, 0, 0, cl2};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(6) = {1, 2, 3, 4};
Plane Surface(6) = {6};
//+
//Physical Curve("empotrar") = {1};
////+
//Physical Curve("empotrar") += {1};
////+
//Physical Curve("tension_remota") = {3};
////+
//Physical Surface("chapa") = {6};
