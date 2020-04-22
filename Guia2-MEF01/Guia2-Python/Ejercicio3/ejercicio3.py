#!/usr/bin/env  python3
# -*- coding: utf-8 -*-
import numpy as np
import sys
import pdb
from scipy.integrate import quad
sys.path.append("../")
import mefmods as mef
import matplotlib.pyplot as plt
import matplotlib
#matplotlib.use('Qt5Agg')


"""
Tengo que definir primero la generación de las fuerzas!
"""


class barra:

    def ND(self, x, L):
        return 1. - x/L

    def NI(self, x, L):
        return x/L

    def Tx(self, x, C):
        return -C*x

    def dfI(self, x, a, L, C):
        return self.NI(x-a, L) * self.Tx(x, C)

    def dfD(self, x, a, L, C):
        return self.ND(x-a, L)*self.Tx(x, C)

    def fuerza(self, MN, C):
        """
        define las fuerzas equivalentes sobre los nodos para la
        distribucuón de fuerzas T(x) = - C*x
        """
        F = np.zeros((len(MN), 1))
        for i in range(len(MN)-1):
            a = self.MN[i, 0]
            b = self.MN[i+1, 0]
            li = b - a
            pdb.set_trace()
            F[i] += quad(lambda x: self.dfI(x, a, li, C), a, b)[0]
            F[i+1] += quad(lambda x: self.dfD(x, a, li, C), a, b)[0]
        return F

    def __init__(self, NNODOS=2, C=10e3, L=0.6):
        self.MN = np.hstack(
                (np.linspace(0, L, NNODOS, dtype=float).reshape(NNODOS, 1),
                    np.zeros((NNODOS, 2)))
                )
        self.MC = np.hstack(
                (np.linspace(0, NNODOS-1, NNODOS-1, dtype=int, axis=0),
                    np.linspace(1, NNODOS, NNODOS-1, dtype=int, axis=0))
                )
        self.F = self.fuerza(self.MN, C)

B = barra(NNODOS=3)
#print(B.MC)
#print(B.MN)
print(B.F)
