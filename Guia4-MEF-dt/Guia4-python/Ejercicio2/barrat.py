#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import mefmods as mef
import meshmods as msh
from scipy.linalg import eigh
import matplotlib.pyplot as plt
import pdb

# primero trato de hacer una matriz de nodos cualquiera

class barra(object):
    """
    la clase barra va a tener las matrices de rigidez y 
    se le puede pedir la evolucion temporal 
    siempre esta aislada en sus bordes
    # Parametros
    L: Longitud
    To: temperatura inicial
    Td: temperatura de fuente externa(a la derecha)
    A: Area
    k: conductividad termica
    C: calor específico
    rho: densidad
    
    # Metodos
    mesh(N): dividir en N elementos
    """
    def __init__(self, L=1, A=np.pi*(0.012/2)**2, rho=2700, k=200, c=900, To=30, Ti=80, Td=30):
        """
        define los atributos de la clase
        """
        self.conductivity = np.array([k, 1])
        self.capacitance = np.array([rho, c])
        self.L = L
        self.To = To
        self.Td = Td
        self.Ti = Ti
        self.K = []
        self.C = []
        self.MPcon = []
        self.MPcap = []

    def mesh(self, N):
        " mallar en N elemenos"
        MC = []
        for n in range(N):
            MC.append([n, n+1])
        self.MC = np.array(MC)
        self.MN = np.hstack(
                (
                    np.linspace(0, self.L, N+1, dtype=float).reshape(-1, 1),
                    np.zeros((N+1, 1))
                    ))
        # la matriz de conductividad es como una matriz de rigidez
        self.MPcon = np.array([[self.conductivity[0], self.conductivity[1]] for n in range(N)], dtype=float)
        # la matriz de capacitancia es como la matriz de masas longitudinal consistente
        self.MPcap = np.array([[self.capacitance[0], self.capacitance[1]] for n in range(N)], dtype=float)
        self.K = mef.ensamble(
                self.MC, self.MN, self.MPcon,
                1, [0]*len(self.MC), case='Conductividad_{}'.format(N)
                )
        self.C = mef.ensamble(
                self.MC, self.MN, self.MPcap,
                1, ['long']*N, case='capacitance_{}'.format(N)
                )
        self.T = np.ones((N+1, 1))*self.To
        self.T[0] = self.Ti
        self.T[-1] = self.Td
        self.r = np.linspace(1, self.T.shape[0]-2, self.T.shape[0]-2, dtype=int)
        self.s = [0, self.T.shape[0]-1]

    def solve_stationary(self, C_, M):
        """
        el estado estacionaro se resuelve a partir de :
        K T = 

        """
        mingl = 1 
        pass

    def evolve(self,  dt=0.1, tmax=5000., to=0., tol=1e-4):
        T = [self.T]
        F = [-self.conductivity.prod()*np.gradient(self.T, axis=0)]
        t = to
        dT = [np.zeros_like(self.T)]
        while t <= tmax:
            t += dt
            aux = np.zeros_like(self.T)
            aux[self.s] = T[-1][self.s]
            aux[self.r] = T[-1][self.r] - dt*np.linalg.solve(
                self.C[np.ix_(self.r, self.r)],
                self.K[np.ix_(self.r, self.r)].dot(T[-1][self.r]) +
                self.K[np.ix_(self.r, self.s)].dot(T[-1][self.s])
                )
            T.append(aux)
            dT.append((T[-1] - T[-2])/dt)
            F.append(
                    self.C.dot(dT[-1])+self.K.dot(T[-1])
                    )
            if abs((abs(F[-1][-1]) - abs(F[-1][0]))/F[-1][0]) < tol:
                break
        T = np.array(T).reshape(len(T), T[-1].shape[0])
        F = np.array(F).reshape(len(F), F[-1].shape[0])

        return T, F


