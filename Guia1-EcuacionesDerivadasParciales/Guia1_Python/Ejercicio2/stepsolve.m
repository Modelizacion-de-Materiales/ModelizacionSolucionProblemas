function Tout=stepsolve(method,Tin,matris)
A=cell2mat(matris(1));
if length(matris)==2 ; B=cell2mat(matris(2)) ; end

if method==1
    Tout=A*Tin;
elseif method==2
    Tout=A\Tin;
elseif method==3
    Tout=A\(B*Tin);
end
    