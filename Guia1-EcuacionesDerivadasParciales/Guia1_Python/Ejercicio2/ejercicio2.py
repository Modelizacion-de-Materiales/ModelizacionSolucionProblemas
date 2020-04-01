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
        A[i, [i-1, i, i+1]] = [-milam, 1.+2.*milam, -milam]
    return A

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
    ALLT = np.zeros((miN, 1), order='C')
    ALLT = np.matmul(miA, miT0)
    ALLF = np.gradient(ALLT, axis=0)
    # defino una flag y un contador para controlar la propagacion
    flag = True
    i = 0
    while flag:
# recupero la ultima lista de temperaturas
        miT0 = ALLT[:, -1].reshape(miN, 1)
# calculo la nueva temperatura
        NEWT = miA.dot(miT0)
        # calculo el nuevo flujo        #
        NEWF = np.gradient(NEWT, axis=0)
        ALLT = np.append(ALLT, NEWT, axis=1)
        ALLF = np.append(ALLF, NEWF, axis=1)
        i = i + 1
        if i > 100:
            # propago solo 100 pasos. 
            # la idea es medirlo con un error
            flag = False

    return ALLT, ALLF


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


def resolv_explicito(midt, midx):
    # Main variables
    lam, T0 = init(midt, midx)
    # x = np.linspace(0, L, N)  # vector de posiciones
    case = 'explicito-lam='+('{:.3f}'.format(lam))
    A = EXPLICITO(len(T0), lam)

    T, FI = MAKET(A, T0, 1e-3, case)


if __name__ == "__main__":
    resolv_explicito(0.5, 1)
