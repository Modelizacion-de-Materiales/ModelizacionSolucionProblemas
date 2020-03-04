function sigma_nod=tennod(nnod,MC,sigma)

nel=size(MC,1);
sigma_nod=zeros(nnod,1);


j=0;
for i=1:nnod
    nodenels=[];
    for j=1:nel
        if any( MC(j,:)==i )
            nodenels=[nodenels,j];
        end
    end
    sigma_nod(i)=mean(sigma(nodenels));
end

