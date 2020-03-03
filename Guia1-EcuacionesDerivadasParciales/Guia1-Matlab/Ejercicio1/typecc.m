function mystr = typecc(tycc)
mystr = '';
for i=1:4 
    if tycc(i)==1
        mystr=strcat(mystr,' Temperatura ');
    elseif (tycc(i)==2)
        mystr=strcat(mystr, ' Flujo ');
    end
end
end

