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
        self.VD, self.VF = self.getvsdf()
        self.plotmesh()

    def plotmesh(self, scale=100):
        NEL, NNXEL = np.shape(self.MC)
        plt.title(self.case)
        # grafico la  matriz de nodos desplazada
        fig, ax = plt.subplots()
        # ax.use_sticky_edges = False
        ax.margins(0.2)
        for e in range(len(self.MC)):
            X = np.reshape(self.MN[self.MC[e, :], 0], (NNXEL, 1))
            Y = np.reshape(self.MN[self.MC[e, :], 1], (NNXEL, 1))
            ax.plot(X, Y, '-ob')
            X2 = X + scale*self.U[self.GL*self.MC[e, :]]
            Y2 = Y + scale*self.U[self.GL*(self.MC[e, :]+1)-1]
            ax.plot(X2, Y2, '-or')
        ax.quiver(
                self.MN[:, 0] + scale*self.VD[:, 0],
                self.MN[:, 1] + scale*self.VD[:, 1],
                self.VF[:, 0],
                self.VF[:, 1]
                )
        fig.savefig('Puente.pdf')
        plt.close()
        return

    def getvsdf(self):
        VD = np.zeros(np.shape(self.MN))
        VF = np.zeros(np.shape(self.MN))
        for n in range(len(self.MN)):
            VD[n, 0] = self.U[self.GL*n]
            VD[n, 1] = self.U[self.GL*(n+1)-1]
            VF[n, 0] = self.F[self.GL*n]
            VF[n, 1] = self.F[self.GL*n+1]
        return VD, VF


P = Grilla(gefile='Puente.ge', case='Puente')
