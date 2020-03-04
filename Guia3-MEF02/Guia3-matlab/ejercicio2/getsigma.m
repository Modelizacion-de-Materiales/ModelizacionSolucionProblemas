function sigma=getsigma(Ux,Uy,NOD,MC,modulo)

n_el=size(MC,1);

for i=1:n_el
    r1=NOD(MC(i,1),:);
    r2=NOD(MC(i,2),:);
    L=norm(r1-r2);
    c=(r2(1)-r1(1))/L;
    s=(r2(2)-r1(2))/L;
    dux=Ux(MC(i,2))-Ux(MC(i,1));
    duy=Uy(MC(i,2))-Uy(MC(i,1));
    dupp=[dux duy]*[c; s];
    sigma(i)=dupp*modulo(i)/L;
end

    