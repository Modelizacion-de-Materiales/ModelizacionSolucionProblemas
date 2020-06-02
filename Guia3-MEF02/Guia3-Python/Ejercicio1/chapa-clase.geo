//Chapa - Ejercicio 1 Guía 2
// Variables
escala=20; L=20; H=10;
// Puntos
Point(1)={0,0,0,escala};
Point(2)={L,0,0,escala};
Point(3)={L,H,0,escala};
Point(4)={0,H,0,escala};
// triangulo inferior
Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,1};
//triangulo superior
// Line(4)={1,3};
Line(5)={3,4};
Line(6)={4,1};
// defino los dos lazos
Line Loop(7) = {1, 2, 3};
Line Loop(8) = {-3, 5, 6};
Plane Surface(9) = {7};
Plane Surface(10) = {8};
