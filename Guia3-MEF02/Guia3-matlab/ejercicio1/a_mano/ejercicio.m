clear all
k = 200 ; % kN / m
do = 0.02 ;
k_el = [ k -k ; -k k ];
K = zeros(4,4);

MC = [1 2 ; 2 3 ; 3 4 ] ;

i1 = MC(1,:);
i2 = MC(2,:);
i3 = MC(3,:);

K(i1,i1) = K(i1,i1) + k_el ; 
K(i2,i2) = K(i2,i2) + k_el ; 
K(i3,i3) = K(i3,i3) + k_el ; 
