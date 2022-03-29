import numpy as np 
import os
import copy
import pdb

def ising ( NSTEPS,N,Hext,kT,J ):
    k = 1
    z = 4 ;           # numero de primeros vecinos. 
    kTc= z*J / 2 ;    # supuesta temperatura crítica.
    To = J / k;       # notar que T puede ser directamente T si kb T = 1
    mu = 1;           # la permeabilidad. 
    beta=1./kT ;      #  

    TRANSIENT=np.ceil(NSTEPS/10).astype(int)
       # idea sacada del paper que me paso ruben.
    NORM = 1/(NSTEPS*N**2) 

    thissize = '{:d}x{:d}'.format(N,N)
    thismcs=f'{NSTEPS}mcs'
    thisfile='output'+thissize+'-'+thismcs+'.dat'
    thisfig=f'output{thissize}-{thismcs}'
    EMEAN = [] #np.array([]*len(kT))
    MMEAN = [] #np.array([]*len(kT))
    MabsMEAN = []
    E2MEAN = []
    VARIANCE = []
    #guardo encabezado de archivo
    with open(thisfile,'w') as f: 
        f.write('# T EMEAN E2MEAN CV MMEAN  Mmean |M|mean siflips noflips \n')
       #kT[t], EMEAN[t], E2MEAN[t], VARIANCE[t]/kT[t]^2, MMEAN[t], MabsMEAN[t],...

       # inicio la distribución de spins. de aca 
       #empieza todo.
    s = np.random.randint(2, size=(N,N))*2-1# sign(rand(N) - 0.5) 
       # primero obtengo la suma de spines en los vecinos. 
         # el enfriamiento.
         # TERMALIZACION A T ALTA
       #  i1 = ceil( rand(NSTEPS,1)*(N) ); 
       #  i2 = ceil( rand(NSTEPS,1)*(N) ); 
    siflips=0; noflips=0
    for i in range(TRANSIENT):     # {
        E, dM, s , siflips, noflips = metropolising(J,beta[1],s,siflips,noflips )
#      disp(['En termalizacion: flips = ',num2str(siflips),...
#        ' rejects= ', num2str(noflips),...
#        ' de ' , num2str(NSTEPS), ' intentos '])

       # la dinámica ocurre en enfriamiento!
       # recien ahora calculo la energía inicial del sistema
    sumOfNeighbours = getneigbours( s )
    E = - ( J / 2 ) * sum ( sum( s*sumOfNeighbours )) + mu*Hext*sum(s); 
    M = sum(sum(s))
       #plotting params
    basename='N_{:02d}'.format(N)

    for t in range(len(kT)):
         #  inicio los acumuladores
         # una diferencia con lo que hacen en el paper que me paso
         # ruben es que hay una instancia de termalización para cada 
         # temperatura, le llama "transient" como si fuera un estado transi
         #torio. lo podemos implementar mas o menos fácil:
         # en esta versión las coordenadas las elijo cuando ejecuto metropoliss.
         # cuento los flips para debug
        siflips=0;  noflips=0
           #  for i = 1:TRANSIENT  % { %TRANSITORIO TRANSIENT_STEPS=NSTEPS/10
           #    [ dE, dM, s , noflips, siflipls ] =  ...
           #       metropolising(J,beta[t],s,noflips,siflips )
           #  end % }
        cases= basename+'_kT_{:02d}'.format( t )
#      fig = figure()
           #  fig.Units='normalized'
#      fig.Position=[0,0,25,10]
#      subplot(1,2,1); colormap summer; grid on; image((s+1)*256);   xticks([]); yticks([]);  title('init')
             # y calculo la energía inicial de la distribución:
             # preparo metropolis
             # en esta versión las coordenadas las genero en la funcion metropolis.
             # cuento los flips para debug !
        sumOfNeighbours = getneigbours( s )
        E = - ( J / 2 ) * sum ( sum( s*sumOfNeighbours )) + mu*Hext*sum(s); 
        M = sum(sum(s))
        siflips=0; noflips=0
         # luego del transitorio inicia los acumuladores parael caso.
        E_ACUM = E;  M_ACUM = M; E2_ACUM = E**2 ;  Mabs_ACUM = M
         # METROPOLIS
        for i in range(NSTEPS): # i = 1:NSTEPS         # {  %%% loop temperatura
            dE,dM,s,siflips,noflips =  metropolising (J,beta[t],s,siflips,noflips)
                 # el cambio de energía lo calculo con el spin propuesto.
#     sumOfNeighbours = getneigbours( s )
#     Etest = - ( J / 2 ) * sum ( sum( s.*sumOfNeighbours )) + mu*Hext*sum(s(:)); 
            E =E + dE ;  
            M = M + dM
# en todos los casos, tengo que procesar la estadística.
            E_ACUM = E_ACUM + E ; Mabs_ACUM=Mabs_ACUM+abs(M); M_ACUM = M_ACUM + M
            E2_ACUM = E2_ACUM + (E)**2
#      subplot(1,2,2); image((s+1)*256);  xticks([]); yticks([]);  title('end'); 
#      title(fig.Children(end), ['kT = ', num2str(kT[t]) , ', size = ', num2str(N),'X', num2str(N)])
             #saveas(fig, [cases,'.pdf'])
#      print([cases,'.pdf'], '-dpdf','-bestfit')
#      close
             # al final de metrópolis tengo que calcular toda la estadística.
        EMEAN.append( E_ACUM/NSTEPS )  #;%   * NORM 
        MMEAN.append(  M_ACUM/NSTEPS ) #;      #* NORM
        MabsMEAN.append(Mabs_ACUM/NSTEPS)
        E2MEAN.append(E2_ACUM/NSTEPS)# ;%  *NORM 
        VARIANCE.append((E2MEAN[t]-EMEAN[t]**2)/NSTEPS  )
        print(f'N = {N}, totalflips = {NSTEPS}, KT = {t}, flips = {siflips}, rejects = {noflips}')
#        with open(thisfile, 'a') as f:
#            f.write('{:15.4e} {:15.4e} {:15.4e} {:15.4e} {:15.4e} {:15.4e} {:d} {:d}\n',format( 
#                  kT[t], EMEAN[t], E2MEAN[t], VARIANCE[t]/kT[t]**2, MMEAN[t], MabsMEAN[t] , siflips, noflips 
#                  )
#                  )
#    system(['LD_PRELOAD="/usr/lib64/libstdc++.so.6" pdftk ',basename,'_kT* cat output ',basename,'.pdf'])
#    system(['rm ',basename, '_kT*.pdf'])
#function [ NNDN ,  NNUP,  NNLE, NNRI ] = getneigbours( s )
    return s,  MMEAN,EMEAN,E2MEAN,MabsMEAN , VARIANCE

def getneigbours(s):
     #%% ojo porque el cricshift esta relentizando el programa ! 
    NNDN = np.roll(s,1 , 0)
    NNUP = np.roll(s,-1,  0)
    NNLE = np.roll(s,0 , 1)
    NNRI = np.roll(s,0 , -1)
    sumofneighbours=NNDN+ NNUP + NNLE + NNRI
    return sumofneighbours

                
   #METROPOLIS FUNCTION                
   #  [dE,dM,s,siflips,noflips] =  ...
   #     metropolising (J,beta[t],s,siflips,noflips)
def metropolising ( J,beta , olds, siflipin,noflipin):
     # en esta funcion se aplica el algoritmo de metrópolis 
     # i,j es el elemento de la distribucion de 
     #spines que se va a cambiar. 
     # sumOfThisNeigbours es la suma de vecinos correspondiente. 
     # elijo al azar las coordenadas a cambiar, 
    [N,M]=olds.shape # size(olds)
    i = np.random.randint(N) #randi(N)
    j = np.random.randint(M)
    sdot = -copy.copy( olds [ i, j ] )
    iup=i-N #mod(i-1-1,size(olds,1))+1
    idn=i-1#mod(i+1-1,size(olds,1))+1
    jup=j-N#mod(j-1-1,size(olds,2))+1
    jdn=j-1 #mod(j+1-1,size(olds,2))+1
    # cambio de energía propuesta. 
    dEdot = -2*(sdot)*(J)*(olds[ iup,j ] + olds[ idn,j ] + olds[ i,jup ] + olds[ i,jdn ]  )
    flip = False; 
    siflipout = siflipin
    noflipout = noflipin; 
    # y ahora viene el cambio por metropolis.
    # si el cambio de energía propuesto es menor que cero o
    # si la proba de cambio
    # es mayor que un número al azar : 
    if dEdot < 0:    # {  en este caso confirmo el cambio de espin:
        flip=True
    else:   # otro caso cualquiera tengo que medir la probabilidad.
          p = np.random.rand() 
    if p < np.exp(-beta*dEdot):    # { si la proba es alta, 
        flip = True
         # en cualquier otro caso, dejo las cosas como estaban. 
       # en principio copio la distribucion original.
    news=copy.copy(olds)
    if flip == True:     # { efectivamente hago el cambio.
        news [ i, j ] = copy.copy(sdot) 
        dE = copy.copy(dEdot)
        dM = 2*sdot
        siflipout=siflipout+1
    else:    # si flip es False,
        dE = 0
        dM = 0
        noflipout=noflipout+1
           # no cambio nada y dE = 0!
    return  dE, dM, news , siflipout, noflipout 



    
