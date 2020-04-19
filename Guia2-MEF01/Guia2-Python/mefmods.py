#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Este es el módulo python de funciones específicas para MEF
"""
import numpy as np
import copy
import pdb
from math import atan2, sin, cos


def resolvermef(r, s, K, us, fr, case):
    """
    U, F = resolvermef(r,s,K,us,fr)
    #
    resuelve el problema de MEF dados los indices de gl incognitas r , y los indices de gl
    vinculados s. arma la ecuación reducida y la resuelve usando numpy.linalg.solve.
    #
    Ur = np.linalg.solve(K[ ix_(r,r) ],  fr - K[ix_(r,s)].dot(us))
    Fs = K[ ix_(s,:) ].dot(U)
    # equivalente a :
    #
    # U(r) = K_rr ^-1 *( fr - K_rs u_s )
    devuelve el vector U y F armados , U[s] = us, U[r] = Ur , F[s] = Fs, F[r]  = fr
    case es un string para identificar el caso
    """
    N = len(K)
    U = np.zeros([N, 1])
    F = np.zeros([N, 1])
    pdb.set_trace()
    U[r] = np.linalg.solve(K(np.ix_(r, r)), fr - K(np.ix_(r, s)).dot(us))
    U[s] = us
    F[s] = K[s, :].dot(U)
    F[r] = fr
    np.savetxt(case+'Forces.dat', F)
    np.savetxt(case+'Displace.dat', U)
    return U, F


def ensamble(MC, MN, props, gl, etype):
    """
    esta función ensambla los elementos indicados por el argumento etype.
    """
    # numero de nodos
    N = len(MN)*gl
    # inicio la matriz global de rigidez
    Kglob = np.zeros([N, N])
    # numero de elementos y de nodos por elemento
    ne, nnxe = np.shape(MC)
    # esta linea es necesaria porque en python los indicesvan desde cero
    for e in range(ne):
        MCloc = MC[e, :]-1  # el -1 va parapasar a indices
        MNloc = MN[MCloc, :]-1
        kele = kelemental(etype, props[e], MNloc, MCloc)
        for i in range(nnxe):
            ni = MCloc[i]
            rangei = np.linspace(i*gl, (i+1)*gl-1, gl).astype(int)
            rangeni = np.linspace(ni*gl, (ni+1)*gl-1, gl).astype(int)
            for j in range(nnxe):
                nj = MCloc[j]
                rangej = np.linspace(j*gl, (j+1)*gl-1, gl).astype(int)
                rangenj = np.linspace(nj*gl, (nj+1)*gl-1, gl).astype(int)
                # atención ahora:
                # ver formulas de apunte de ensamble de matrices
                # print(e, rangei, rangej)
                Kglob[np.ix_(rangeni, rangenj)] += kele[np.ix_(rangei, rangej)]
    return Kglob


def kelemental(etype, k, NODES=None, CONEC=None):
    """ arma la matriz elemental segun etype

    etype == 1: resortes unimensionales [ 1 -1 , -1 1]
    """
    if etype == 1:  # caso etype =resortes
        kel = k*np.array([[1, -1], [-1, 1]], dtype=float)
    elif etype == 2: # caso etipe = barras 
        """
        En este caso voy a necesitar la matriz de nodos local
        y la matriz de conectividad local.
        """
        kel = np.zeros((4, 4))
        X = NODES[:, 0]
        Y = NODES[:, 1]
        THETA = np.arctan2(np.diff(X), np.diff(Y))
        c2 = cos(THETA)**2
        cs = cos(THETA)*sin(THETA)
        s2 = sin(THETA)**2

        kel = np.array( 
                [
                    [c2, cs, -1*c2, -1*cs], [cs, s2, -1*cs, -1*s2],
                    [-1*c2, -1*cs, c2, cs], [-1*cs, -1*s2, cs, s2]
                    ]
                )
        # algunas veces los cos y sin dan valores muy bajos. entonces:
        tol = 1e-16
        kel[abs(kel) < tol] = 0.0
    return kel


def getgeo(filename):
    with open(filename) as fi:
        for line in fi:
            if line.strip() == 'NODES':
                NNODES = np.int(fi.readline())
                MN = np.zeros((NNODES, 3), dtype=float)
                for i in range(NNODES):
                    thisnode = np.fromstring(
                            fi.readline().strip(), dtype=float, sep=' '
                            )
                    MN[i, :] = thisnode
            elif line.strip() == 'ELEMENTS':
                DIMELEM = np.fromstring(
                        fi.readline().strip(), dtype=int, sep=' '
                        )
                NELEM = DIMELEM[0]
                NNXEL = DIMELEM[1]
                MC = np.zeros((NELEM, NNXEL), dtype=int) 
                # Matriz de propiedades, inicio para 2 propiedades, luego corrijo
                MP = np.zeros(NELEM, 2)
                for i in range(NELEM):
                    thiselem = np.fromstring(
                            fi.readline().strip(),dtype=int, sep=' '
                            )
                    MC[i, :] = thiselem[1:NNXEL]
                    MP[i, :] = thiselem[NNXEL:]
            if line.strip() == 'GL':
                # GL = np.fromstring(fi.readline(), dtype=int, sep=' ')
                GL = int(fi.readline())
    return GL, MC, MN, MP
