#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy as np
import sys
sys.path.append("../")
import mefmods as mef
import pdb
import matplotlib.pyplot as plt

# GL: Grados de libertad por nodo,
# MC: matriz de conectividad
# MN: Matriz de nodos
# MP: Matriz de propiedades
# LVIN: Listas de Vínculos = (IVIN, MVIN): indices de vinculo (nodo, eje1, eje2), (Vin1, vind2))
#         si eje1 > 0 Vin1 es desplazamiento,
#         si eje1 < 0 vin1 es fuerza


class Grilla:

    def __init__(self, gefile='Puente.ge', case='puente'):
        self.GL, self.MC, self.MN, self.MP, self.LVIN = mef.getgeo(gefile)
        self.gefile = gefile
        self.case = case
        self.R, self.S, self.US, self.FR = mef.makevins(self.GL, len(self.MN), self.LVIN)
        self.K = mef.ensamble(self.MC, self.MN, self.MP, self.GL, 2)
        self.U, self.F = mef.resolvermef(self.R, self.S, self.K, self.US, self.FR, case)
        np.savetxt('Desplazamientos.dat', self.U)
        np.savetxt('Fuerzas.dat', self.F)
        self.plotmesh()

    def plotmesh(self):
        NEL, NNXEL = np.shape(self.MC)
        plt.title(self.case)
        for e in range(len(self.MC)):
            X = np.reshape(self.MN[self.MC[e, :], 0], (NNXEL, 1))
            Y = np.reshape(self.MN[self.MC[e, :], 1], (NNXEL, 1))
            plt.plot(X, Y, '-ob')
            X2 = X + 100*self.U[self.GL*self.MC[e, :]]
            Y2 = Y + 100*self.U[self.GL*(self.MC[e, :]+1)-1]
            plt.plot(X2, Y2, '-or')
        plt.savefig('Puente.pdf')

P = Grilla(gefile='Puente.ge', case='Puente')
