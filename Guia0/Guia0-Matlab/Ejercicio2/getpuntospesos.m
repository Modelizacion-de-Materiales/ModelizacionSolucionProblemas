MAXIT=10;
N=3;
M=(N+1)/2;
x=zeros(N,1);
a=-1; b=1;
tol = 1e-4 ;

xm=(a+b)/2;
x1=(b-a)/2;

z=cos( pi*([1:M]-0.25 )/(N+0.5) );

finished=false;

p1=zeros(N+1,N-1);
p2=zeros(N+1,N-1);
i = 0 ;

zo = 2; 
while finished==false && i <= MAXIT
    i = i + 1;
    
%     for j = 1:N
%         p3 = p2;    
%         p2 = p1; 
%         p1 = ((2*j - 1)*z.*p2 - (j-1)*p3)/j;
%     end
%     daabout
%     pp = N*(z.*p1-p2)./(z.^2 - 1.0 );
%     z1 = z;
%     z = z1 - p1./pp ; 
%     
%     for k = 1:size(z) 
%         if pp(k) < eps(z1)
%             z(k)=0;
%         end
%     end

    p1 = ones(N+1,1) ; 
    p2 = zeros(N-1,1) ; 
   
    p3=ones(N-1,1) ; 
    p1 = z; 
    
    
    
    % x = [ xm - x1*z , xm+x1*z ] ;
    x(1:M) = xm - x1*z ; 
    x(N:-1:N-M+1) = xm+x1*z ;
    w(1:M) = 2.0 * x1 ./ ( (1.0 - z.^2).*(pp.^2) );
    w(N:-1:N-M+1) = w(1:M);
        
    err = abs( z - z1 ) ;
    
    if any ( err > tol )
        finished = false ; 
    else
        finished = false ; 
    end
    
end
    