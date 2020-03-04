% Esta función escribe la geometría para la chapa rectangular de
% dimensiones bi:bd x binf:bsup, con un agujero de radio R ubicado en
% (ejey,ejey+z). La geometría se guarda en el archivo filename (que debe
% tener extensión .geo para ser procesado por gmsh. Los puntos cercanos a
% la entalla tienen un factor de escala 1.0 / sr, de manera de refinar el
% mallado en la zona. 

function fid=writegeo(z,R,bi,bd,binf,bsup,scf,sr,filename)

ejex=(bsup+binf)/2;
ejey=(bi+bd)/2;
h=bsup-ejex;

if z<=R
    [points,circles,lines,loops,surfs]=mkcentered();
elseif (z>R) && z<h-R
    [points,circles,lines,loops,surfs]=mkmiddle();
elseif z+R>=h
    [points,circles,lines,loops,surfs]=mktop();
end

npoints=size(points,1);
ncircles=size(circles,1);
nlines=size(lines,1);
nloops=size(loops,2);
nsurf=size(surfs,1);

fid=fopen(filename,'w');
for i=1:npoints
    fprintf(fid,'Point (%d)={%6.4f,%6.4f,%6.4f,%6.4f};\n',i,points(i,:));
end

for i=1:ncircles
     fprintf(fid,'Circle (%d)={%d,%d,%d};\n',i,circles(i,:));
end

for i=1:nlines
    fprintf(fid,'Line (%d)={%d,%d};\n',ncircles+i,lines(i,:));
end
for i=1:nloops
    thisloop=loops{i};
    fmt='Line Loop(%d)={';
    for j=1:length(thisloop)-1;
        fmt=[fmt,'%d,'];
    end
    fmt=[fmt,'%d};\n'];
    fprintf(fid,fmt,nlines+ncircles+i,thisloop(:));
end
for i=1:nsurf
    fprintf(fid,'Plane Surface (%d)={%d};\n',ncircles+nlines+nloops+i,surfs(i,:));
end
%%% Compute element sizes from point values
fprintf(fid,'Mesh.CharacteristicLengthFromPoints = 1;\n');
fprintf(fid,'Mesh.CharacteristicLengthFromCurvature = 1;\n');
fclose(fid);


    function [points,circles,lines,loops,surfs]=mkcentered()
        x=sqrt(R^2-z^2);
        points=[ ejex, ejey+z, 0.0 , scf/sr ;... % centro del agujero  %% 1
            ejey,ejex+z-R,0.0,scf/sr;...       % primer punto de la circunferencia.  %% 2
            ejey+x,ejex,0.0,scf/sr;...         % segundo  %% 3
            ejey, ejex+z+R, 0.0,scf/sr;...     % tercero  % 4
            ejey-x,ejex,0.0,scf/sr;...         % cuarto  %% 5
            % y ahora vienen las líneas:
            bi,binf,0.0,scf;...                % vertice abajo izquierda %% 6
            ejey,binf,0.0,scf;...                % vertice abajo, medio  %% 7
            bd,binf,0.0,scf;...                % vertice derecho abajo  %% 8
            bd,ejex,0.0,scf;...                % derecha, medio  %% 9
            bd,bsup,0.0,scf;...                %derecha arriva %% 10
            ejey,bsup,0.0,scf;...           % arriva medio %% 11
            bi,bsup,0.0,scf;...                % izquierda medio %% 12
            bi,ejex,0.0,scf ];                 % medio izquierdo. %% 13
        circles=[ 2,1,3;...                    % semicírculo abajo-ejex %% 1
            3,1,4;...                          % semicriculo ejex-arriba %%  2
            4,1,5;...                          % semiccírculo arriba - ejex % 3
            5,1,2 ];                           % semicírculo ejex-abajo. %% 4
        lines=[ 6, 7;... % linea 5
            7, 8;...     % línea 6
            8,9;...      % línea 7
            9,10;...     %línea 8
            10,11;...    % linea 9
            11,12;...      % línea 10
            12,13;...     % linea 11
            13,6;...      % linea 12
            % y ahor alas lineas de los ejes;
            2,7;...      % linea 13
            3,9;...      % linea 14
            4,11;...     % linea 15
            5,13];       % linea 16
        loops={[ 5,-13,-4,16,12],... %primer loop 17
            [6,7,-14,-1,13],...  % loop 18
            [14,8,9,-15,-2],... %loop 19
            [-16,-3,15,10,11]}; %ultimo loop 20
        surfs=[ 17;... %surf 21
            18;... % surf 22
            19;... % surf 23
            20]; % surf 24
    end


    function [points,circles,lines,loops,surfs]=mkmiddle()
        points=[ejey,ejex+z,0.0,scf/sr;...  %  punto 1 en el centro del circulo
            ejey,ejex+z-R,0.0,scf/sr;...       % primer punto de la circunferencia.  %% 2
            ejey, ejex+z+R, 0.0,scf/sr;...     % tercero  % 3
            % y ahora los vertices, necesito uno en el centro
            ejey,ejex,0.0,scf/sr;...           % centro, punto 4
            bi,binf,0.0,scf;...                % vertice abajo izquierda %% 5
            ejey,binf,0.0,scf;...              % vertice abajo, medio  %% 6
            bd,binf,0.0,scf;...                % vertice derecho abajo  %% 7
            bd,ejex,0.0,scf;...                % derecha, medio  %% 8
            bd,bsup,0.0,scf;...                %derecha arriva %% 9
            ejey,bsup,0.0,scf/sr;...               % arriva medio %% 10
            bi,bsup,0.0,scf;...                % izquierda medio %% 11
            bi,ejex,0.0,scf ];                 % medio izquierdo. %% 14
        circles=[2,1,3;... % semicirculo abajo-arriba
            3,1,2 ]; % semicírculo arriba-abajo
        lines=[5,6;...% línea 3
            6,7;... %linea 4
            7,8;... %linea 5
            8,9;... %linea 6
            9,10;...% linea 7
            10,11;...% linea 8
            11,12;...% linea 9
            12,5;... %linea 10
            4,6;... %linea 11
            4,8;... %linea 12
            4,2;... %linea 13
            3,10;... %linea 14
            4,12];    %linea 15
        loops={[3,-11,15,10],... %Loop 16
            [4,5,-12,11],... %Loop 17
            [12,6,7,-14,-1,-13],... %Loop 18
            [-15,13,-2,14,8,9]}; % Loop 19
        surfs=[16;... % Plane surface 20
            17;...% Plane surface 21
            18;...% Plane surface 22
            19];% Plane surface 23
    end


    function [points,circles,lines,loops,surfs]=mktop()
        x=sqrt(R^2-(h-z)^2);
        points=[ejey,ejex+z,0.0,scf/sr;... % primero el centro del ajugero, 1
            ejey+x,h,0.0,scf/sr;...   % 2
            ejey-x,h,0.0,scf/sr;...       % 3
            ejey,ejex+z-R,0.0,scf/sr;...
            % y ahora los ejes
            ejey,ejex,0.0,scf;...           % centro, punto 5
            bi,binf,0.0,scf;...                % vertice abajo izquierda %% 6
            ejey,binf,0.0,scf;...              % vertice abajo, medio  %% 7
            bd,binf,0.0,scf;...                % vertice derecho abajo  %% 8
            bd,ejex,0.0,scf;...                % derecha, medio  %% 9
            bd,bsup,0.0,scf;...                %derecha arriva %% 10
            ejey,bsup,0.0,scf/sr;...               % arriva medio %% 11
            bi,bsup,0.0,scf;...                % izquierda medio %% 12
            bi,ejex,0.0,scf ];                 % medio izquierdo. %% 13       
        circles=[4,1,2; %circle 1
            3,1,4];    % circle 2
        lines=[6,7;... % line 3
            7,8;...  %line 4
            8,9;... %line 5
            9,10;...%line 6
            10,2;...%line 7
            3,12;...%line 8
            12,13;...%line 9
            13,6;...%line 10
            5,7;...%line 11
            5,9;...%line 12
            5,4;...%line 13
            5,13]; %line 14
        loops={[3,-11,14,10],...%loop 15
            [4,5,-12,11],...%loop 16
            [12,6,7,-1,-13],...%loop 17
            [-14,13,-2,8,9]};%loop 18
        surfs=[15;... %surf19
            16;...%loop 20
            17;...%loop 21
            18];%loop 22
    end
end

    
    
        
        
        