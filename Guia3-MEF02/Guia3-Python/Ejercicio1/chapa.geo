cl1 = 1;
Point(1) = {0, 0, 0, cl1};
Point(2) = {0, 10, 0, cl1};
Point(3) = {20, 10, 0, cl1*5};
Point(4) = {20, 0, 0, cl1*5};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(6) = {1, 2, 3, 4};
Plane Surface(6) = {6};
Physical Line("embedded") = {2};
Physical Line("stress") = {4};
Physical Surface("sheet") = {6};
