import numpy as np 
import os
import copy
import pdb
import pandas as pd

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
    M2MEAN = []
    E2MEAN = []
    VARIANCE = []
    #guardo encabezado de archivo
    if os.path.exists(thisfile):
        result =  pd.read_csv(thisfile, header=0, sep='\s+')
        if result.shape[0] == len(kT):
            return result
#    with open(thisfile,'w') as f: 
#        f.write('T   EMEAN    E2MEAN        CV           MMEAN   |M|mean   M2MEAN   siflips   noflips \n')

       # inicio la distribución de spins. de aca 
       #empieza todo.
    s = np.random.randint(2, size=(N,N))*2-1# sign(rand(N) - 0.5) 
    # primero obtengo la suma de spines en los vecinos. 
    # el enfriamiento.
    siflips=0; noflips=0
    for i in range(TRANSIENT):     # {
        E, dM, s , siflips, noflips = metropolising(J,beta[1],s,siflips,noflips )
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
        cases= basename+'_kT_{:02d}'.format( t )
        sumOfNeighbours = getneigbours( s )
        E = - ( J / 2 ) * sum ( sum( s*sumOfNeighbours )) + mu*Hext*sum(sum(s)); 
        M = sum(sum(s))
        siflips=0; noflips=0
         # luego del transitorio inicia los acumuladores parael caso.
        E_ACUM = E;  M_ACUM = M; E2_ACUM = E**2 ;  Mabs_ACUM = M; M2_ACUM = M**2;
        for i in range(NSTEPS): # i = 1:NSTEPS         # {  %%% loop temperatura
            dE,dM,s,siflips,noflips =  metropolising (J,beta[t],s,siflips,noflips)
            E =E + dE ;  
            M = M + dM
            E_ACUM += E
            Mabs_ACUM += abs(M)
            M_ACUM += M
            E2_ACUM += E**2
            M2_ACUM += M**2
             # al final de metrópolis tengo que calcular toda la estadística.
        EMEAN.append( E_ACUM/NSTEPS/N**2 )
        MMEAN.append( M_ACUM/NSTEPS/N**2 )
        MabsMEAN.append(Mabs_ACUM/NSTEPS/N**2)
        M2MEAN.append(M2_ACUM/NSTEPS/N**4)
        E2MEAN.append(E2_ACUM/NSTEPS/N**4)
        VARIANCE.append((E2MEAN[t]-EMEAN[t]**2)/NSTEPS  )
        print(f'N = {N}, totalflips = {NSTEPS}, KT = {t}, flips = {siflips}, rejects = {noflips}')
#        with open(thisfile, 'a') as f:
#            f.write(f'{kT[t]:15.4e} {EMEAN[t]:15.4e} {E2MEAN[t]:15.4e} {VARIANCE[t]/kT[t]**2:15.4e} {MMEAN[t]:15.4e} {MabsMEAN[t]:15.4e} {M2MEAN[t]:15.4e}  siflips:d} {noflips:d}\n')
    data = {'T': kT,
            'EMEAN': EMEAN,
            'E2MEAN': E2MEAN,
            'CV': VARIANCE/kT**2,
            'MMEAN': MMEAN, 
            '|M|mean' :  MabsMEAN,
            'M2MEAN' : M2MEAN
           }
    result = pd.DataFrame.from_dict(data, orient='index')
    
    result.to_csv(thisfile, sep=' ', index=False, )
    
    return result

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
    Nx,Ny = olds.shape # size(olds)
    i = np.random.randint(Nx) #randi(N)
    j = np.random.randint(Ny)
    sdot = -copy.copy( olds [ i, j ] )
    iup=i-Nx
    idn=i-1
    jup=j-Ny
    jdn=j-1
    # cambio de energía propuesta. 
    dEdot = -2*(sdot)*(J)*(olds[ iup,j ] + olds[ idn,j ] + olds[ i,jup ] + olds[ i,jdn ]  )
    flip = False
    siflipout = siflipin
    noflipout = noflipin
    if dEdot < 0:    
        flip=True
    else:   
        if np.random.rand() < np.exp(-beta*dEdot):   
            flip = True
    news=copy.copy(olds)
    if flip == True:     # { efectivamente hago el cambio.
        news [ i, j ] = copy.copy(sdot) 
        dE = copy.copy(dEdot)
        dM = 2*sdot
        siflipout=siflipout+1
    else:    
        dE = 0
        dM = 0
        noflipout=noflipout+1
    return  dE, dM, news , siflipout, noflipout 
    
def init():
    Hext = 0;      # el campo externo 
    J = 1;         # la constante de interacción. 
    # rango y sampleo de temperaturas:
    
    kTmax=5
    kTmin=kTmax/6#; dkT = (kTmax-kTmin)/51; 
    kT=np.linspace(kTmax,kTmin,50);
    return Hext,J,kT 

if __name__ == '__main__':
    [Hext,J,kT]=init()
    #s0,MMEAN0,EMEAN0,E2MEAN0,MABSMEAN0, VARIANCE0 =ising(int(1e5), 2,Hext,kT,J);
    for N in [2,4,8, 16]:
        for MCsteps in [5e4, 1e5, 5e5]:
             ising(int(MCsteps), N,Hext,kT,J)