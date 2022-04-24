#!/usr/bin/env python3
"""

dt = 0.61379 #seg
dt = 0.6 # comportamiento estable
dt  =  0.65 comportamiento inestable.
Ta = 100  # temperatura borde izquierdo
Tb = 50   # temperatura borde derecho


"""
# vim: source ~/.vim/ftplugin/python.vim

import pdb
import numpy as np
#import matplotlib
#matplotlib.use('Qt5agg')
import matplotlib.pyplot as plt


def EXPLICITO(miN, milam):
    """
    Esta función genera la matriz para el método explicito de integración
    temporal por difereincas finitas
    input :
     miN : Número de nodos
     milam : lambda
    return:
     M
    donde
    T^{l+1} = M T^l
    """
    A = np.identity(miN)
    for i in range(1, miN-1):
        A[i, [i-1, i, i+1]] = [milam, 1.-2.*milam, milam]
    return A


def CN(miN, milam):
    L = np.identity(miN)
    R = np.identity(miN)
    for i in range(1, miN-1):
        L[i, [i-1, i, i+1]] = np.array([-milam, 2*(1+milam), -milam])
        R[i, [i-1, i, i+1]] = np.array([milam, 2*(1-milam), milam])
    return np.matmul(np.linalg.inv(L), R)


def MAKET(miA, miT0, TOL, case, verbose=False, dx = 1):
    """
    Propaga  la condición inicial miT0 usando la matriz 
    miA como propagador, de manera que 
    T^{l+1} = miA*T^l
    donde l es el índice temporal l = {0,...,maxl} , donde 
    max el se genera para que el error en el flujo de calor 
    en el borde sea menor que la tolerancia TOL
    ---------------
    inputs: 
    - miA: matriz de propagación
    - miT0 : condición inicial
    - TOL : tolerancia en el flujo
    - case : string para agregar al nombre de archivo
    ---------------
    outputs: ALLT, ALLFI, ALLFD
    - ALLT : archivo, ALLT.dat , donde se guarda la serie de temperaturas.
    - ALLF: archivo, ALLF.dat donde se guardan los flujos.
    """
    miN = len(miA)
    # las temperaturas y flujos van a ir en matrices
    ALLT = miT0
#    ALLT = np.matmul(miA, miT0)
    ALLF = np.gradient(ALLT, axis=0)
    # defino una flag y un contador para controlar la propagacion
    flag = True
    i = 0
    ERR = np.array([]) # np.zeros((1, 200))
    while flag:
        i = i + 1
# recupero la ultima lista de temperaturas
        miT0 = ALLT[:, -1].reshape(miN, 1)
# calculo la nueva temperatura
        NEWT = miA.dot(miT0)
        NEWF = np.gradient(NEWT, dx,  axis=0)
        ALLT = np.append(ALLT, NEWT, axis=1)
        ALLF = np.append(ALLF, NEWF, axis=1)
        # tengo que calcular el error de alguna manera.
        # El Error lo mido con el cambio de flujo
        #newerr = np.abs( (ALLF[-1, :] - ALLF[-2,:])/ALLF[-1,:] ).sum()
        newerr = np.abs( (ALLF[:, -1] - ALLF[-1,-1])).sum()/miN #/ALLF[-1,-1] )
        ERR = np.append(ERR, newerr) # np.abs(np.diff(ALLF[-1, [0,-1]])/ALLF[-1, -1]))
        if (i >= 500) | (ERR[-1] < TOL) | (ERR[i-1] > 1000):
            # propago solo 200 pasos.
            # la idea es medirlo con un error
            flag = False
            if verbose:
                print("se detiene propagacion temporal en i = {:d}".format(i))
    return ALLT, ALLF, ERR


# inicio como matriz identidad para que me queden guardados
# las condiciones de contorno

def init(midt, midx):
    L = 10  # cm
    k = 0.835  # cm^2/s , Al
    lam = k*midt/(midx**2)  # lambda
    setN = np.int(L / midx + 1 )
    T0 = np.zeros((setN, 1))
    T0[0] = 50
    T0[-1] = 100   
    X = np.linspace(0,L,setN)
    return lam, T0, X


def plotlistT(theTlist, dt,  milam, dx = 1, L = 10,   ncurves = 5, maketags = True, maketitle=True,  savepdf = True, ax=None, fig=None, returntags = False,  **kwargs):
    TS = np.loadtxt(theTlist).transpose()
    N, NT = np.shape(TS)
    X = np.linspace(0,L,N)
    losTs1 = np.logspace(0, np.log10(NT), ncurves).astype(int)-1
    losTags1 = [r'$t =$ {:.1f}'.format(val*dt) for val in losTs1]
    lostagsy = TS[np.int(N/2)-1, losTs1]
    lostagsx = [np.int(N/2)-1]*len(lostagsy)
    if ax == None:
        fig, ax = plt.subplots()
    ax.plot(X, TS[:, losTs1], '--ok')
    method = theTlist.split('-')[1]
    if maketags:
        tags = []
        for thistagx, thistagy, thistag, thisT in zip(lostagsx, lostagsy, losTags1, losTs1):
            dy =  TS[thistagx+1, thisT]-TS[thistagx, thisT] 
            rot =(180/np.pi)*np.arctan(dy / dx)
            text=ax.text(X[thistagx], thistagy, thistag, rotation=rot, rotation_mode='anchor', transform_rotates_text=True)
            tags.append( text.set_bbox({'facecolor':'white', 'alpha':0.7}) )
    ax.set_xlabel('X')
    ax.set_title(rf'Método {method}, $\delta t = {dt:.4f}, \lambda = {milam:.4f}$')#.format(dt, milam))
    ax.set_ylabel(r'T ($^{o}C$)')
    ax.set_xlim(0, max(X))
#    fig.tight_layout()
    #plt.show()
    if savepdf:
        figfile = theTlist.replace('.dat', '.pdf')
        fig.savefig(figfile)
    if returntags:
        return  fig, ax, tags
    else:
        return fig, ax


def plotlistF(theFlist, lam, method='explicito',maketitle=True,  ax=None, fig=None, savepdf=True, **kwargs):
    FS = np.loadtxt(theFlist).transpose()
    if ax == None:
        fig, ax = plt.subplots(**kwargs)
    ax.plot(FS[0,:], label='Flujo a izquerda')
    ax.plot(FS[-1,:], label ='Flujo del lado derecho')
    ax.axhline(color='k')
    ax.set_xlabel('time index')
    ax.set_ylabel('Flujo')
    if maketitle:
        ax.set_title(rf'$\lambda = {lam}$, método {method}')
    ax.legend()
    if savepdf:
        thefigfile = theFlist.replace('.dat','.pdf')
        fig.savefig(thefigfile)
    return fig, ax

def plotlistE(theElist, lam, method='explicito', maketitle=True, ax=None, fig=None, savepdf=True, **kwargs):
    ES = np.loadtxt(theElist).transpose()
    if ax == None:
        fig, ax = plt.subplots(**kwargs)
    ax.semilogy(ES)
    ax.set_xlabel('time index')
    ax.set_ylabel('Error = $|\sum_i (Q_{i} - Q_{derecha})|/n$')
    if maketitle:
        ax.set_title(rf'$\lambda = {lam}$, método {method}')
    if savepdf:
        thefigfile = theElist.replace('.dat','.pdf')
        fig.savefig(thefigfile)
    return fig, ax

def generic_resolv(milam, miT0, tol=1e-3,  method=EXPLICITO):
    case = f'{method.__name__}-lam={milam:.3f}'
    tempfile = 'T-'+case+'.dat'
    fluxfile = 'F-'+case+'.dat'
    errfile = 'E-'+case+'.dat'
    A = method(len(miT0), milam)
    T, F, E = MAKET(A, miT0, tol, case, verbose=False)
    np.savetxt(tempfile, T.transpose(), fmt='%.6e')
    np.savetxt(fluxfile, F.transpose(), fmt='%.6e')
    np.savetxt(errfile, E.transpose(), fmt='%.6e')
    return {'tempfile': tempfile, 'flujofile': fluxfile, 'errfile':  errfile}

def resolv_explicito(milam, miT0):
    case = 'explicito-lam='+('{:.3f}'.format(milam))
    tempfile = 'T-'+case+'.dat'
    fluxfile = 'F-'+case+'.dat'
    errfile = 'E-'+case+'.dat'
    A = EXPLICITO(len(miT0), milam)
    T, F, E = MAKET(A, miT0, 1e-3, case, verbose=False)
    np.savetxt(tempfile, T.transpose(), fmt='%.6e')
    np.savetxt(fluxfile, F.transpose(), fmt='%.6e')
    np.savetxt(errfile, E.transpose(), fmt='%.6e')
    return tempfile, fluxfile, errfile


def resolv_CN(milam, miT0):
    case = 'CN-lam='+('{:.3f}'.format(milam))
    tempfile = 'T-'+case+'.dat'
    fluxfile = 'F-'+case+'.dat'
    errfile = 'E-'+case+'.dat'
    A = CN(len(miT0), milam)
    T, F, E = MAKET(A, miT0, 1e-3, case)
    np.savetxt(tempfile, T.transpose(), fmt='%.6e')
    np.savetxt(fluxfile, F.transpose(), fmt='%.6e')
    np.savetxt(errfile, E.transpose(), fmt='%.6e')
    return tempfile, fluxfile, errfile


if __name__ == "__main__":
    """
    dt = 0.61379 #seg
    dt = 0.6 # comportamiento estable
    dt  =  0.65 comportamiento inestable.
    Ta = 100  # temperatura borde izquierdo
    Tb = 50   # temperatura borde derecho
    """
    dt = 0.65
    dx = 1

    lam, T0 = init(dt, dx)

    file1, file2, file3 = resolv_explicito(lam, T0)
    plotlistT(file1, dt, lam)


    filecn1, filecn2, filecn3 = resolv_CN(lam, T0)
    plotlistT(filecn1, dt, lam)
