%[s2,MMEAN2,EMEAN2,E2MEAN2]=ising(1E4,  16,Hext,kT,J);
[Hext,J,kT]=init()
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(4E4, 2,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(1e5, 2,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5E5, 2,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(1E6, 2,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5E6, 2,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e4, 4,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(1e5, 4,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e5, 4,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e4, 8,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(1e5, 8,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e5, 8,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e4, 16,Hext,kT,J);
%[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(1e5, 16,Hext,kT,J);
[s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0]=ising(5e5, 16,Hext,kT,J);


function [Hext,J,kT]=init()
  Hext = 0;      % el campo externo 
  J = 1;         % la constante de interacción. 
  % rango y sampleo de temperaturas:
  kTmax=6; kTmin=kTmax/50; dkT = (kTmax-kTmin)/50; 
  kT=linspace(kTmax,kTmin,(kTmax-kTmin)/dkT);
end

