function K=ensamble2(casename,MC,gl,Kgl,kel)


[n_el, n_nxel]=size(MC);
K=Kgl;

fout=['matriz',casename,'.dat'];
fid=fopen(fout,'w');
fmt=[];

for i=1:size(K,2); fmt=[fmt,' %6.4e']; end
fmt=[fmt,' \n'];

for i=1:n_nxel
    for j=1:n_nxel;
        K( (MC(i)-1)*gl+1:MC(i)*gl ,(MC(j)-1)*gl+1:MC(j)*gl)=...
            Kgl( (MC(i)-1)*gl+1:MC(i)*gl ,(MC(j)-1)*gl+1:MC(j)*gl)+...
            kel( (i-1)*gl+1:i*gl , (j-1)*gl+1:j*gl );
    end
end

fprintf(fid,'\n Matriz Global Terminada \n');
for i=1:size(K,1) ; fprintf(fid,fmt,K(i,:) ); end
fclose(fid);



