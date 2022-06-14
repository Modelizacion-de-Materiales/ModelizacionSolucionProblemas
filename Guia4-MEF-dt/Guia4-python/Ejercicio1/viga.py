#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import mefmods as mef
from scipy.linalg import eigh
import matplotlib.pyplot as plt
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
                    1, [0]*len(self.MC), case='Stiff_long_{}'.format(N)
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
                    1, ['long']*N, case='Masas_long_{}'.format(N)
                    )
        elif etype == 'long_lump':
            self.M = mef.ensamble(
                    self.MC, self.MN, self.MPM,
                    1, ['long_lump']*N, case='Masas_long_{}'.format(N)
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

    def solvemods(self, K_, M_, mode='trans'):
        if 'long' in mode:
            mingl = 1
        else:
            mingl = 2
        w, vl = eigh(K_[mingl:, mingl:], M_[mingl:, mingl:])
        v = np.vstack((np.zeros((mingl, vl.shape[1])), vl))
        return np.sqrt(w)/(2*np.pi), v

    def converge_study(self, Nmax, Modemax, mode):
        ws = np.nan*np.zeros((Nmax, Modemax))# [[] for i in range(Nmax)]
        Vs = [[] for i in range(Nmax)]
        for N in range(Nmax):
            self.mesh(N+1, mode)
            Wl, Vl = self.solvemods(self.K, self.M, mode=mode)
            imax = min(Modemax, len(Wl))
#           ws[N].append([np.nan]*Modemax)
            ws[N, :imax] = Wl[:imax]
            Vs[N].append(Vl[:, :imax])
        return ws, Vs

    def InterpolateAllElements(self, ds, modes, _glxn=1, interpolators = [mef.NL1DA, mef.NL1DB]):
        x = {}
        y = {}
        xx = {}
        yy = {}
        for nnodes in np.arange(3,10):
            x[nnodes] = np.linspace(0,1,nnodes)
            y[nnodes] = {}
            xx[nnodes] = {}
            yy[nnodes] = {}
            for mode in modes:
                if mode > ds[nnodes-2][0].shape[1]:
                    continue
                thismode = ds[nnodes-2][0][:,mode-1]
                y[nnodes][mode] = thismode[::_glxn]
                xx[nnodes][mode], yy[nnodes][mode] = mef.Interpolate1DSolutions(x[nnodes], thismode, interpolators=interpolators, glxn=_glxn)
        return x, y, xx, yy


    def plot_modes(self, modes, x,y,xx,yy):
        from matplotlib import lines as mlines 
        from itertools import cycle
        plt.rc('font', size=16)
        markersymbols = ['o','s','d','^', 'P', 'X', 'h', '*']
        markercycle = cycle(markersymbols[:len(modes)])
        interpoline = mlines.Line2D([],[], linestyle = '--', color='k')
        fig, ax = plt.subplots(len(modes), 1, sharex = True, figsize=(10, 2.5*len(modes)))
        for mode, tax in zip(modes, ax):
            ls = []
            solution_handles = []
            for NNODES in np.arange(3,6): #,4]:
                if mode > len(y[NNODES]):
                    continue
                thismarker = next(markercycle)
                scatter = tax.scatter(x[NNODES],y[NNODES][mode]/y[NNODES][mode][-1], marker=thismarker, ec='k', s=100) #, ms=30/(NNODES-2)))
                ls.append(tax.plot(xx[NNODES][mode], yy[NNODES][mode]/y[NNODES][mode][-1], '--', c = scatter.get_facecolor(), label=f'{NNODES} nodos'))
                solution_handles.append(mlines.Line2D([],[], marker=thismarker, markerfacecolor='k', color='k',  ms=10))
            tax.set_ylabel(f'modo {mode}') #'$y/y_{max}$')
            solution_handles += [interpoline]
            solution_labels = [l[0].get_label() for l in ls]+['interpolación']
        ax[-1].set_xlabel('$x (m)$')
        ax[0].legend(handles = solution_handles, labels=solution_labels, loc='upper center', bbox_to_anchor=(0.5, 1.3),  ncol=len(modes), fontsize=16)
        fig.tight_layout()
        return fig, ax


# V.solvemods
