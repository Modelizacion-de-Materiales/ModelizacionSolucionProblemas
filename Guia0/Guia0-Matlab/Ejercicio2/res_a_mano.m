%%% Solución del problema 2 de la guia 1.

%% función que define la fuerza

% intervalos de integración

a = 0;
b = 30 ; 

df=@funf;
dd=@(z) z.*df(z);

dz = 0.05 ; 
N=round((b - a)/dz);

[F_trapecios,esf_trap] = trapecios(a,b,dz,df);
[F_simpson,esf_simp] = simpson(a,b,dz,df);
[F_gauss,esf_gauss] = miquad(a,b,N,df);
