function i=findinterval(xo,X)

for j = 1:length(X)-1
    isthere(j) = X(j)<=xo && X(j+1)>xo;
end

i = find(isthere);