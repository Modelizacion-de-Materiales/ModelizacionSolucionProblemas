#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Este es el módulo python de funciones específicas para MEF
"""
import numpy as np
import copy
import pdb
from math import atan2, sin, cos, sqrt
import re


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
    U[r] = np.linalg.solve(K[np.ix_(r, r)], fr - K[np.ix_(r, s)].dot(us))
    U[s] = us
    F[s] = K[s, :].dot(U)
    F[r] = fr
    np.savetxt(case+'Forces.dat', F)
    np.savetxt(case+'Displace.dat', U)
    return U, F


def ensamble(MC, MN, MP, gl, etype):
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
        MNloc = MN[MCloc, :]
        kele = kelemental(etype, MP[e,:], MNloc, MCloc)
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


def kelemental(etype, MP, NODES=None, CONEC=None):
    """ arma la matriz elemental segun etype

    etype == 1: resortes unimensionales [ 1 -1 , -1 1]
    """
    if etype == 1:  # caso etype =resortes
        kel = MP*np.array([[1, -1], [-1, 1]], dtype=float)
    elif etype == 2: # caso etipe = barras 
        """
        En este caso voy a necesitar la matriz de nodos local
        y la matriz de conectividad local.
        """
        kel = np.zeros((4, 4))
        X = NODES[:, 0]
        Y = NODES[:, 1]
        dx = np.diff(X)
        dy = np.diff(Y)
        THETA = atan2(dy, dx)
        L = sqrt(dx**2 + dy**2)
        c2 = cos(THETA)**2
        cs = cos(THETA)*sin(THETA)
        s2 = sin(THETA)**2
        # pdb.set_trace()
        kel = (MP[0]*MP[1]/L)*np.array(
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
            if '#' in line.strip():
                continue
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
                MP = np.zeros((NELEM, 2), dtype=float)
                for i in range(NELEM):
                    thiselem = np.fromstring(
                            fi.readline().strip(), sep=' '
                            )
                    MC[i, :] = thiselem[1:NNXEL+1]
                    MP[i, :] = thiselem[NNXEL+1:]
            if line.strip() == 'GL':
                # GL = np.fromstring(fi.readline(), dtype=int, sep=' ')
                GL = int(fi.readline())
            if line.strip() == 'VINS':
                # voy a armar la matriz de vinculos
                NVINS = np.int(fi.readline())
                MVIN = np.zeros((NVINS, GL), dtype=float)
                IVIN = np.zeros((NVINS, 1+GL), dtype=int)
                # la matriz de vinculos siempre tiene la definicion de las fuerzas y de los
                # desplazamientos
                for v in range(NVINS):
                    thisvin = np.fromstring(
                            fi.readline().strip(), sep=' '
                            )
                    IVIN[v, :] = thisvin[:1+GL]
                    MVIN[v, :] = thisvin[1+GL:]
    return GL, MC, MN, MP, (IVIN, MVIN)

def makevins(GL, NNODES, LVIN):
    """
    lee la lista de vinculos y lo transforma en los vectores r y s, us y fr
    """
    nvins = 0
    nincs = 0
    r = np.empty((0, 1), dtype=int)
    fr = np.empty((0, 1), dtype=float)
    s = np.empty((0, 1), dtype=int)
    us = np.empty((0, 1), dtype=float)

    IVIN, MVIN = LVIN
    for i in range(len(IVIN)):
        node, dir1, dir2 = IVIN[i, :]
        if dir1 > 0:
            np.append(s, node*gl)
            np.append(us, MVIN[i, 0], axis=0)
        


        pdb.set_trace()
        pass



