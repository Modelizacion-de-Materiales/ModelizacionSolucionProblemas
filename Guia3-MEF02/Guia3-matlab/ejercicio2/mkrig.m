% function K = mkrig(problem,gl,NOD,MC,{modulo1,modulo2, seccion,...})
% Esta función genera la matriz de rigidez del problema dado, funcionando
% como interfaz de la subrutina 'mklocs', que genera las matrices locales.
% Aquí se llama a tal subrutina para generar las mismas y luego se las
% ensambla utilizando 'ensamble2'.
%
% problem:  =1 : resortes, debe agregar modulo (k)
%           =2 : barras, debe agregar modulo y sección (E, A)
%           =3 : barras a flección, debe agregar modulo, momento de inercia,
%           seccion (E, I, A)
% gl:  grados de libertad.
% NOD: matriz de nodos
% MC : Matriz de conectividad
% modulos: cualquier otra información física del sistema. Generalmente en
% este orden: E, nu, I, A, ...

function K = mkrig(problem,gl,NOD,MC,varargin)

% recupero las dimensiones del problema:
[nels nnxel]=size(MC);  % numero de elementos y numero de nodos por elemento
[nnod dim] = size(NOD); % numero de nodos y dimensionalidad.

% inicializo la matriz global
K = zeros(nnod*gl,nnod*gl);

%para guardar las matrices en archivos, uso encabezados
file1=['MatrizGlobal-',num2str(nels),'els.dat']; % nombre del archivo donde guardo la matriz global
heading1='Matriz Global \n ============== \n';   % encabezado del mismo
fmt1=[];for col=1:nels*gl ; fmt1=[fmt1,' %6.4e ']; end ; fmt1=[fmt1,'\n']; % guardo el numero de columnas y un formato adecuado.

file2=['MatricesElementales-',num2str(nels),'els.dat' ]; % archivo de las matrices elementales.
heading2='\n Matriz elemental elemento %d \n =================== \n '; % encabezado particular un elemento
heading3='Matrices Elementales \n '; % encabezado general
fmt2=[];for col=1:nnxel*gl ; fmt2=[fmt2,' %6.4e ']; end ; fmt2=[fmt2,'\n']; % formato de cada línea (num cols)

% archivo de las matrices elementales, 
fid=fopen(file2,'w'); %abro.
fprintf(fid,heading3); % imprimo encabezado.

% me guardo el numero de módulos pasados
nmods=size(varargin,2);

% main loop.
for i = 1:nels   % recorro todos los elementos
    
    % le voy a pasar a mklocs todos los modulos necesarios para el elemento
    % actual:
    for j = 1:nmods
        modulo{j}=varargin{j}(i);
    end
    
    % llamo a mklocs para generar la matriz del elemento actual
    kloc = mklocs(problem,MC(i,:),NOD(MC(i,:),:),gl,i,modulo{1:nmods});
    
    % y la ensamblo
    K=ensamble2(MC(i,:),NOD(MC(i,:),:),gl,kloc,K);
    
    % En el archivo de salida guardo la matriz elemental actual, para
    % referencias. 
    fprintf(fid,heading2,i); % titulo de la matriz actual
    fprintf(fid,fmt2,kloc);  % matriz propiamente dicha. 
end    

% por último salvo la matriz global en un archivo, para referencias. 
save('MatrizGlobal.dat','K','-ascii');
    