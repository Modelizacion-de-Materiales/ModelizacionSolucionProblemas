#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy as np
import sys
import os
_my_dir = os.path.dirname(__file__)
_my_parent = os.path.pardir
sys.path.append(_my_parent)
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
    """
    Esta clase resuelve los problemas de la ménsula y el puente de la guía 2 usando los métodos en el módulo mefmods.
    """

    def __init__(self, gefile='Puente.ge', case='puente'): #, pltscale=100):
        """
        Iniciación de la instancia Grilla.

        parámetos:
        =========
        gefile: nombre del archivo de geometría y vínculos
        case: string con identificador del caso
        """
        # obtener los parámetros geométricos del archivo de geometría
        self.GL, self.MC, self.MN, self.MP, self.ET, self.LVIN = mef.getgeo(gefile)
        # definir la propiedad de la clase.
        self.gefile = gefile
        self.case = case
        # hacer los índices de vinculos e incógnitas con los datos del archivo.
        self.R, self.S, self.US, self.FR = mef.makevins(self.GL, len(self.MN), self.LVIN)
        # ensamblar las matrices
        self.K = mef.ensamble(self.MC, self.MN, self.MP, self.GL, self.ET, self.case)
        # resolver el sistema con nuestro método de siempre
        self.U, self.F = mef.resolvermef(self.R, self.S, self.K, self.US, self.FR, self.case)
        np.savetxt(case+'Desplazamientos.dat', self.U)
        np.savetxt(case+'Fuerzas.dat', self.F)
        self.VD, self.VF = self.getvsdf()
#        fig = self.plotmesh(pltscale)
#        fig.show()

    def plotmesh(self, scale=100):
        NEL, NNXEL = np.shape(self.MC)
        # grafico la  matriz de nodos desplazada
        fig, ax = plt.subplots()
        ax.set_title(self.case)
        # ax.use_sticky_edges = False
        ax.margins(0.2)
        for e in range(len(self.MC)):
            X = np.reshape(self.MN[self.MC[e, :], 0], (NNXEL, 1))
            Y = np.reshape(self.MN[self.MC[e, :], 1], (NNXEL, 1))
            ax.plot(X, Y, '-ob', label='Estructura Inicial')
        handles, labels = ax.get_legend_handles_labels()
        display = [len(self.MC)-1, len(self.MC)-1+len(self.MN)]
        ax.legend([handle for i, handle in enumerate(handles) if i==len(self.MC)-1],
                [label for i, label in enumerate(labels) if i==len(self.MC)-1])
        fig.savefig(os.path.join(_my_dir, self.case+'Inicial.pdf'))
        for e in range(len(self.MC)):
            X = np.reshape(self.MN[self.MC[e, :], 0], (NNXEL, 1))
            Y = np.reshape(self.MN[self.MC[e, :], 1], (NNXEL, 1))
            X2 = X + scale*self.U[self.GL*self.MC[e, :]]
            Y2 = Y + scale*self.U[self.GL*(self.MC[e, :]+1)-1]
            ax.plot(X2, Y2, '-or', label='Estructura Cargada')
        ax.quiver(
                self.MN[:, 0] + scale*self.VD[:, 0],
                self.MN[:, 1] + scale*self.VD[:, 1],
                self.VF[:, 0],
                self.VF[:, 1],
                label='Fuerzas'
                )
        ax.set_title('Desplazamientos x{}'.format(scale))
        handles, labels = ax.get_legend_handles_labels()
        display = [len(self.MC)-1, len(self.MC)-1+len(self.MN), len(labels)-1]
        ax.legend([handle for i, handle in enumerate(handles) if i in display],
                [label for i, label in enumerate(labels) if i in display])
        fig.savefig(os.path.join(_my_dir, self.case+'Final.pdf'))
        plt.close()
        return fig

    def getvsdf(self):
        VD = np.zeros(np.shape(self.MN))
        VF = np.zeros(np.shape(self.MN))
        for n in range(len(self.MN)):
            VD[n, 0] = self.U[self.GL*n]
            VD[n, 1] = self.U[self.GL*(n+1)-1]
            VF[n, 0] = self.F[self.GL*n]
            VF[n, 1] = self.F[self.GL*n+1]
        return VD, VF


#M = Grilla(gefile='./Mensula.g', case='Mensula', pltscale=1)
# P = Grilla(gefile='./Puente.ge', case='Puente', pltscale=100)
#M = Grilla(gefile='./Mensula-niro.g', case='Mensula-niro', pltscale=1)
