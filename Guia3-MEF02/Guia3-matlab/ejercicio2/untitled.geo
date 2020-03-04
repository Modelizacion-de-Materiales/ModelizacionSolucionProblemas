Point(1) = {0, 0, 0, 1.0};
Point(2) = {0, 10, 0, 1.0};
Point(3) = {20, 10, 0, 1.0};
Point(4) = {20, 0, 0, 1.0};
Delete {
  Point{4};
}
Point(4) = {20, 0, 0, 0.01};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {1, 4};
Line Loop(5) = {2, 3, -4, 1};
Plane Surface(6) = {5};
