function nodos=getnodos(thismsh)

fid=fopen(thismsh,'r');
done=0; % indicar si se han leido todos los nodos
while (~feof(fid) && done ~= 1 )
    line=fgetl(fid);
    if regexp(line,'\$Nodes')
        n_n=strread(fgetl(fid));
        nodos=zeros(n_n,3);
        for i=1:n_n
            thisnod=strread(fgetl(fid));
            nodos(thisnod(1),:)=thisnod(2:end);
        end
        done=1;
    end
end
            %thisline=strread(fgetl(fid));
    