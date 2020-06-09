#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import mefmods as mef
from scipy.linalg import eigh
import pdb

# primero trato de hacer una matriz de nodos cualquiera

class Viga(object):
    """
    la clase viga va a tener las matrices de rigidez y 
    se le puede pedir los modos de bibracion, tanto longitudinales como transversales
    pero, la viga siempre va a estar empotrada en el primer nodo.
    # Parametros
    L: Longitud
    E: Young modulus
    A: Area
    rho: densidad
    I: momento de inhercia
    
    # Metodos
    mesh(N): dividir en N elementos
    get_modes(type): obtener modos de bibracion, type = long, trans (con sus respectivos lump)
    """
    def __init__(self, L, E, A, rho, I):
        """
        define los atributos de la clase
        """
        self.inertia = [rho, A]
        self.stiff = [E, A, I]
        self.L = L
        self.K = []
        self.M = []
        self.MPM = []
        self.MPS = []

    def mesh(self, N, etype):
        MC = []
        for n in range(N):
            MC.append([n, n+1])
        self.MC = np.array(MC)
        self.MN = np.hstack(
                (
                    np.linspace(0, self.L, N+1, dtype=float).reshape(-1,1),
                    np.zeros((N+1, 1))
                    ))
        # matriz de rigidez para los modos transversales
        if 'long' in etype:
            # propiedades de masa y stiffnes longitudinal:
            # propiedades de stiffness longitudinal: A y E
            self.MPS = np.array([[self.stiff[0], self.stiff[1]] for n in range(N)], dtype=float)
            # la matriz de rigidez es la mimsa para lumo y no lump
            self.K = mef.ensamble(
                    self.MC, self.MN, self.MPS,
                    2, [0]*len(self.MC), case='Stiff_long_{}'.format(N)
                    )
        elif 'trans' in etype:
            # en el caso de transversal, las prpiedades de stiffnes son momento de inercia  y area
            self.MPS = np.array([[self.stiff[2], self.stiff[0]] for n in range(N)], dtype=float)
            # la matriz de rigidez es la mimsa para lumo y no lump
            self.K = mef.ensamble(
                    self.MC, self.MN, self.MPS,
                    2, [3]*len(self.MC), case='Stiff_trans_{}'.format(N)
                    )
        # ma matriz de propiedades de masa siempre es la misma: densidad y Area
        self.MPM = np.array([[self.inertia[0], self.inertia[1]] for n in range(N)], dtype=float)
        if etype == 'long':
            self.M = mef.ensamble(
                    self.MC, self.MN, self.MPM,
                    2, ['long']*N, case='Masas_long_{}'.format(N)
                    )
        elif etype == 'long_lump':
            self.M = mef.ensamble(
                    self.MC, self.MN, self.MPM,
                    2, ['long_lump']*N, case='Masas_long_{}'.format(N)
                    )
        elif etype == 'trans':
            self.M = mef.ensamble(
                    self.MC, self.MN, self.MPM,
                    2, ['trans']*N, case='Masas_long_{}'.format(N)
                    )
        elif etype == 'trans_lump':
            self.M = mef.ensamble(
                    self.MC, self.MN, self.MPM,
                    2, ['trans_lump']*N, case='Masas_long_{}'.format(N)
                    )

    def solvemods(self):
        w, vl = eigh(self.K[2:, 2:], self.M[2:, 2:])
        v = np.vstack((np.zeros((2, vl.shape[1])), vl))
        return np.sqrt(w)/(2*np.pi), v

    def converge_study(self, Nmax, Modemax, mode):
        ws = [[] for i in range(Modemax)]
        Vs = [[] for i in range(Modemax)]
        for N in range(Nmax):
            self.mesh(N, mode)
            Wl, Vl = self.solvemods(self.K, self.M)


V = Viga(1, 210e9, 10e-4, 7850, 10e-8)
V.mesh(3, 'trans')
#V.solvemods
