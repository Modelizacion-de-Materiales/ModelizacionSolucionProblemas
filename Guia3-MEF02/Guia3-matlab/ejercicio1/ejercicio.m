
thismsh='chapa-sym';
system(['rm ',thismsh,'-out.msh']);
gl=2;
E=30e6; %psi
nu=0.3;
t=1; %inch
sigma_ext=1000; % tension remota, psi

[NOD,MC]=readmsh([thismsh,'.msh']);
[us,fr,r,s]=mkvin(NOD,MC,gl,t,sigma_ext);
K=mkrigid(MC,NOD,gl,E,nu,t);
%%
Kred=K(r,r);
ur=Kred\fr;
ngl=size(NOD,1)*gl;
%%
U=zeros(ngl,1);
U(r)=ur;
U(s)=us;
F(r)=fr;
F(s)=K(s,:)*U;
%%
nnodo=size(NOD,1);
[nels nnxel]=size(MC);
Ux=U(1:gl:ngl);
Uy=U(2:gl:ngl);
Fx=F(1:gl:ngl);
Fy=F(2:gl:ngl);

% calcular tensiones
tensiones=getsigma(U,NOD,MC,E,nu,t);
A=(tensiones(:,1)+tensiones(:,2))/2;
B=sqrt( (tensiones(:,1)-tensiones(:,2) ).^2/4 + tensiones(:,3).^2 );
principales=[ A+B , A-B , tensiones(:,3) ];
sigmax_nod=tennod(nnodo,MC,principales(:,1));
sigmash_nod=tennod(nnodo,MC,principales(:,3));

% Escribir msh
fid=writemsh(NOD,MC,[thismsh,'-out.msh']);
nodedatablock([thismsh,'-out.msh'],nnodo,'"Displacement (m) " ',3,0,0.0,[Ux Uy zeros(nnodo,1)] );
nodedatablock([thismsh,'-out.msh'],nnodo,'"Forces (N) " ',3,0,0.0,[Fx' Fy' zeros(nnodo,1)] );
elementdatablock([thismsh,'-out.msh'],nels,'" sigma x (Pa)"',1,0,0.0,principales(:,1));
nodedatablock([thismsh,'-out.msh'],nnodo,'"sigma x (Pa,av) " ',1,0,0.0,sigmax_nod);
nodedatablock([thismsh,'-out.msh'],nnodo,'"shear (Pa,av) " ',1,0,0.0,sigmash_nod);
