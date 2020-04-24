%%%%%%%%%%%%%%%% main ejercicio 2

a = 0; b= 30 ; % limites de integración.

%% Inicio el valor de las integrales.
% primer numero de pasos a probar.
df=@funf;
dd=@(z) z.*df(z);
[FT,esfT] = trapecios(a,b,(b-a),df);
[FS,esfS] = simpson(a,b,(b-a),df);
[FG,esfG] = miquad(a,b,1,df);

%% luego inicio variables para iteración.

i = 0 ; 
done = false;
err = 0;
tol = 1e-4;

% primer numero de pasos a probar


while ~ done
    i = i+1 ;
    if i==1
        N(i)=round( (b-a)/5.0 ); %% esto es solo para que el primer tamaño de paso sea el que pide el ejercicio.
    else
        dN=round(N(i-1)*(10.0^0.1-1.)+1);
        N(i)=N(i-1)+dN;
    end
    if mod(N(i),2) == 0 
            N(i)=N(i)+1;
    end
    dx(i) = (b-a)/N(i);
    
    [FT(i+1),esfT(i+1)]=trapecios(a,b,dx(i),@funf);
    [FS(i+1),esfS(i+1)] = simpson(a,b,dx(i),@funf);
    [FG(i+1),esfG(i+1)] = miquad(a,b,N(i),@funf);
    
    err(i,1) = abs((FT(i+1)-FT(i))/FT(i+1));
    if (err(i,1) == 0) ; err(i,1) = eps; end
    err(i,2) = abs((FS(i+1)-FS(i))/FS(i+1));
    if (err(i,2) == 0) ; err(i,2) = eps; end
    err(i,3) = abs( (FG(i+1)-FG(i))/FG(i+1) );
    if (err(i,3) == 0) ; err(i,3) = eps; end
    
    if ~ any( err(i,:) > tol )
        done = true;
    else 
        done = false;
    end
    
end

%% Cálculo de las distancias equivalentes
%para los valores convergidos, calculo las distancias.

%por trapecios
[DT,esfDT] = trapecios(a,b,dx(i),dd);
DT = DT/FT(end);

%por simpson
[DS,esfDS] = simpson(a,b,dx(i),dd);
DS = DS/FS(end);

%por gauss
[DG,esfDG] = miquad(a,b,N(i),dd);
DG = DG/FG(end);

%% Gráfico de convergenca
% valor de la integral
%%
close all
I = num2str(FG(end),'$I_{gauss} = %4.5g$');
D = num2str(DG(end),'$d_{gauss} = %4.5g$' );
figerrs=figure(1);
loglog(N,err(:,1),'ko-','displayname','trapecios','linewidth',2);
hold on
loglog(N,err(:,2),'ro-','displayname','Simpson','linewidth',2);
loglog(N,err(:,3),'bo-','displayname','Cuadratura Gauss-legendre','linewidth',2);
title(['errores en la integral, ',I,'  ',D],'fontsize',14)
legend('location','east');
xlabel('numero de intervalos considerados','fontsize',14);
ylabel('$\Bigl \vert \dfrac{ I_N - I_{N-1}}{I_N} \Bigr \vert $','fontsize',14) 
set(gca,'position',[0.2,0.15,0.7,0.7])
set(gca,'fontsize',12)
%saveas(figerrs,'Errores.pdf','pdf');
print 'Errores.pdf' -dpdflatex





    

