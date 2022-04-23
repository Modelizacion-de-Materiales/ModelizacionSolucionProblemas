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


def MAKET(miA, miT0, TOL, case):
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
        # calculo el nuevo flujo        #
        NEWF = np.gradient(NEWT, axis=0)
        ALLT = np.append(ALLT, NEWT, axis=1)
        ALLF = np.append(ALLF, NEWF, axis=1)
        # tengo que calcular el error de alguna manera.
        # El Error lo mido con el cambio de flujo
        ERR = np.append(ERR, np.abs(np.diff(ALLF[-1, -2:])/ALLF[-1, -1]))
        if (i >= 200) | (ERR[-1] < TOL) | (ERR[i-1] > 100):
            # propago solo 100 pasos.
            # la idea es medirlo con un error
            flag = False
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
    return lam, T0


def plotlistT(theTlist, dt,  milam, dx = 1):
    TS = np.loadtxt(theTlist).transpose()
    N, NT = np.shape(TS)
    losTs1 = np.linspace(0, (NT-1)/3, 5).astype(int)
    losTags1 = [r'$t =$ {:.1f}'.format(val*dt) for val in losTs1]
    losTs1 = np.append(losTs1, NT-1)
    losTags1.append(r'$t = ${:.1f}'.format(NT*dt))
    lostagsy = [y+1 for y in TS[np.int(N/2)-1, losTs1]]
    lostagsy.append(TS[np.int(N/2-1), NT-1])  # el ultimo tag
    lostagsx = [np.int(N/2) for i in range(len(lostagsy))]
    plt.plot(TS[:, losTs1], '--ok')
    for i in range(len(losTags1)):
        segmentoy = np.array([
            TS[lostagsx[i], losTs1[i]],
            TS[lostagsx[i]+1, losTs1[i]]
            ])
        rot = np.array(
                [(90/np.pi)*np.arctan2(TS[4, losTs1[i]] - TS[3, losTs1[i]],
                    dx), ]
                )
        textloc = np.array([lostagsx[i], segmentoy[1]])
        realrot = plt.gca().transData.transform_angles(
                rot, textloc.reshape((1, 2))
                )[0]
        plt.text(lostagsx[i]-1, lostagsy[i], losTags1[i], rotation=realrot)  # rot*45/(np.pi/4.))
    plt.xlabel('X')
    plt.title(r'$\delta t = {:.2f}, \lambda = {:.3f}$'.format(dt, milam))
    plt.ylabel(r'T ($^{o}C$)')
    plt.xlim(0, N-1)
    plt.show()
    figfile = theTlist.replace('.dat', '.pdf')
    plt.savefig(figfile)
    plt.close()


def plotlisF(thelist, dt):
    pass


def resolv_explicito(milam, miT0):
    # Main variables
    # x = np.linspace(-1, L, N)  # vector de posiciones
    case = 'explicito-lam='+('{:.3f}'.format(milam))
    tempfile = 'T-'+case+'.dat'
    fluxfile = 'F-'+case+'.dat'
    errfile = 'E-'+case+'.dat'
    A = EXPLICITO(len(miT0), milam)
    T, F, E = MAKET(A, miT0, 1e-3, case)
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
