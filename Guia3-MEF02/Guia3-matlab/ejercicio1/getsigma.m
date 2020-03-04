function sigma=getsigma(U,NOD,MC,varargin)
modulo=varargin{1};
pois=varargin{2};
espe=varargin{3};

n_el=size(MC,1);

for i=1:n_el
    Uel=zeros(2*3,1);
    for j=1:3;
        Uel(2*(j-1)+1)=U(2*(MC(i,j)-1)+1);
        Uel(2*j)=U(2*MC(i,j));
    end
    
    X=NOD(MC(i,:),1);
    Y=NOD(MC(i,:),2);

    %alfa
    ai=X(2)*Y(3)-Y(2)*X(3);
    aj=X(1)*Y(3)-Y(1)*X(3);
    am=X(1)*Y(2)-Y(1)*X(2);
    
    %beta
    bi=Y(2)-Y(3);
    bj=Y(3)-Y(1);
    bm=Y(1)-Y(2);
    
    %gama
    gi=X(3)-X(2);
    gj=X(1)-X(3);
    gm=X(2)-X(1);
    
    A=0.5*det([ones(3,1) X Y] );
    
    B=[ bi 0 bj 0 bm 0 ; 0 gi 0 gj 0 gm ; gi bi gj bj gm bm ]/(2*A);
    
    D = [ 1 pois 0 ; pois 1 0 ; 0 0 0.5*(1-pois) ]*modulo/(1-pois^2);
    
    sigma(i,:)=(D*B*Uel)';
end

    