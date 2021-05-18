#!/usr/bin/env  python3
# -*- coding: utf-8 -*-
import numpy as np
import sys
sys.path.append("../")
import pdb
from scipy.integrate import quad
import mefmods as mef
import matplotlib.pyplot as plt
import os.path
#import matplotlib
#matplotlib.use('Qt5Agg')


class barra:

    def __init__(self, NNODOS=2, C=20e5, L=1.5, A=10e-4, E=210E9):
        # Inicio variables internas
        self.NNODOS = NNODOS
        self.U = np.zeros((NNODOS, 1), dtype=float)
        self.F = np.zeros((NNODOS, 1), dtype=float) 
        self.case = '{:02d}N'.format(NNODOS)
        self.C = C
        self.L = L
        self.A = A
        self.E = E
        self.GL = 1  # 1 grado de libertad por nodo
        # Soluciones Teóricas
        self.X = np.linspace(0, L)
        self.do = self.teodes(self.X)
        self.to = self.teosig(self.X)
        # Matrices Conectividad , nodos y Propiedades
        self.MN = np.hstack(
                (np.linspace(0, L, self.NNODOS, dtype=float).reshape(self.NNODOS, 1),
                    np.zeros((self.NNODOS, 2)))
                )
        self.MC = np.hstack(
                (np.linspace(0, self.NNODOS-2, self.NNODOS-1, dtype=int, axis=0),
                    np.linspace(1, self.NNODOS-1, self.NNODOS-1, dtype=int, axis=0))
                ).reshape((NNODOS-1, 2))
        self.ET = np.ones(len(self.MC))
        self.MP = self.E*self.A / (self.L / (self.NNODOS - 1)) * \
            np.ones((NNODOS-1, 1))
        # Matriz de rigidez
        self.K = mef.ensamble(self.MC, self.MN, self.MP, self.GL, self.ET, self.case)
        # condiciones de contorno y soluion
        self.Fext = self.fuerza()
        self.R = np.linspace(0, self.NNODOS-2, NNODOS-1, dtype=int)
        self.S = np.array([NNODOS-1], dtype=int)
        # finalmente resuelvo el problema
        self.U, self.F = mef.resolvermef(self.R, self.S, self.K,
                self.U[self.S], self.Fext[self.R], self.case)
        self.Sig = self.tension()

    #  Defino Funciones propias
    def NI(self, x, l):
        return 1. - x/l

    def ND(self, x, l):
        return x/l

    def Tx(self, x):
        return -self.C*x

    def dfI(self, x, a, l):
        return self.NI(x-a, l) * self.Tx(x)

    def dfD(self, x, a, l):
        return self.ND(x-a, l)*self.Tx(x)

    def teodes(self, x):
        return (x**3 - self.L**3)*abs(self.C)/(6*self.A*self.E)

    def teosig(self, x):
        return x**2 * abs(self.C) / (2*self.A)

    def tension(self):
        """ 
        las tensiones las voy a calcular como los estiramientos por los Modulos Elasticos.
        Debe notarse que las tensiones calculadas son Constantes dentro de cada 
        elemento.
        """
        return np.diff(self.U, axis=0)*self.E/(self.L/(self.NNODOS-1))

    def tension_bien(self):
        """
        Estas tensiones las calculo usando los desplazamientos locales
        """
        Keles = mef.read_local_matrices('MatricesElementales-'+self.case)
        U=self.U.reshape((self.NNODOS, self.GL))
        for e in range(self.MC.shape[0])




    def plot_teos(self, force=False):
        """
        test si el gráfico está hecho, luego plot del desplazamiento
        y la tensión teóricos en pdf.
        """
        despfile = 'DesplazamientoTeorico.pdf'
        sigmfile = 'TensionTeorica.pdf'
        flag1 = os.path.exists(despfile) and os.path.isfile(despfile)
        flag2 = os.path.exists(sigmfile) and os.path.isfile(sigmfile)
        if (not flag1) or (not flag2) or (force):
            x = np.linspace(0, B.L, 100)

        if (not flag1) or force:
            plt.plot(self.X, self.do, 'k')
            plt.title('Desplazamiento Teórico')
            plt.xlabel(r'$x (m)$')
            plt.ylabel(r'$d(x)$ (m)')
            plt.savefig(despfile)
            plt.close()

        if (not flag2) or force:
            plt.plot(self.X, self.to, 'k')
            plt.title('Tensión Teórica')
            plt.ylabel(r'$\sigma (x)$ (Pa)')
            plt.xlabel(r'$x$ (m)')
            plt.savefig(sigmfile)
            plt.close()

        return

    def fuerza(self):
        """
        define las fuerzas equivalentes sobre los nodos para la
        distribucuón de fuerzas T(x) = - C*x
        """
        F = np.zeros((len(self.MN), 1))
        for i in range(len(self.MN)-1):
            a = self.MN[i, 0]
            b = self.MN[i+1, 0]
            li = b - a
            F[i] += quad(lambda x: self.dfI(x, a, li), a, b)[0]
            F[i+1] += quad(lambda x: self.dfD(x, a, li), a, b)[0]
        return F

    def plot_results(self):
        dresfile = 'ResultadoDesplazamientos-'+self.case+'.pdf'
        plt.plot(self.MN[:, 0], self.U, '-o', label='Solucion MEF')
        plt.plot(self.X, self.do, '--k', label='Solución Teórica')
        plt.title('Solución Numérica para {:d} nodos'.format(self.NNODOS))
        plt.xlabel(r'$x$ (m)')
        plt.ylabel(r'$d(x)$ (m)')
        plt.legend()
        plt.savefig(dresfile)
        plt.close()
        tresfile = 'ResultadoTensiones-'+self.case+'.pdf'
        plt.plot(self.X, self.to, '--k', label='Solución Teórica')
        plt.title('Solución Numérica para {:d} nodos'.format(self.NNODOS))
        plt.xlabel(r'$x$ (m)')
        plt.ylabel(r'$\sigma$ (GPa)')
        TENY = np.vstack( ([0.0], self.Sig) )
        plt.step(self.MN[:, 0], TENY, 'r',
                where='pre', label='Solución Numérica')
        plt.legend()
        plt.savefig(tresfile)
        plt.close()


# NODOS = [2, 3, 4, 5]
# for i in range(len(NODOS)):
#     B = barra(NODOS[i])
#     B.plot_results()
