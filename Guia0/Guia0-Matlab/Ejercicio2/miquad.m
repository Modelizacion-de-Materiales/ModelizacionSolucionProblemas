
function [I,esfuerzo] = miquad(a,b,N,fun)
%cambio de variables
L=@(c,m,t) m*t+c;
%%% m=(b-a)/2; c=(a+b)/2;
%%% t -> 1 , L = b, m + c = b
%%% t ->-1 , L = a,-m + c = a 
%%% [ c m  ] = [ -1 1 ; 1 1 ] \ [ a ; b ];
A = [ -1 1 ; 1 1 ];
C = A\[a ; b];


%%
err=0;
    tic;
    [X,W,iters]=lgwt(N,-1,1);
    time1=toc;
    I=C(2)*fun(L(C(1),C(2),X'))*W;
    time2=toc;
    esfuerzo = length(X)*(time2-time1)/time2 + iters*time1/time2;