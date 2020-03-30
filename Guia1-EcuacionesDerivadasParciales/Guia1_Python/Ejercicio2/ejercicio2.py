#!/usr/bin/env python3
"""

Python source code - replace this with a description of the code and write the code below this text.

"""
## vim: source ~/.vim/ftplugin/python.vim

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
    for i in range(1, N-1):
        A[i, [i-1, i, i+1]] = [-milam, 1.+2.*milam, -milam]
    return A

def MAKET(miA, miT0, TOL):
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
    ---------------
    outputs: ALLT, ALLFI, ALLFD
    - ALLT : archivo, ALLT.dat , donde se guarda la serie de temperaturas.
    - ALLF: archivo, ALLF.dat donde se guardan los flujos.
    """

    miN = len(miA)
    ALLT = np.zeros((miN, 1), order='C')
    print(ALLT)
    print(miA)
    ALLT = np.matmul(miA, miT0)
    ALLF = np.diff(ALLT)
    np.savetxt('Temperatures.dat', ALLT)

    return ALLT, ALLF


# inicio como matriz identidad para que me queden guardados
# las condiciones de contorno


if __name__ == "__main__":
    # Main variables
    L = 10  # cm
    k = 0.835  # cm^2/s , Al
    dx = 1  # cm, la idea es dejarlo fijo y hacer todo en función de dt.
# dt = 0.61379 #seg
    dt = 0.6138  # comportamiento critico
# dt = 0.6 # comportamiento estable
# dt  =  0.65 comportamiento inestable.
    lam = k*dt/(dx**2)  # lambda
    Ta = 100  # temperatura borde izquierdo
    Tb = 50   # temperatura borde derecho
    N = np.int(L/dx + 1)  # cantidad de nodos.
    x = np.linspace(0, L, N)  # vector de posiciones
    A = EXPLICITO(N, lam)
    T0 = np.zeros((N, 1))
    T0[0] = 50
    T0[-1] = 100

    T, FI = MAKET(A, T0, 1e-3)
