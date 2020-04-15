"""
Este es el módulo python de funciones específicas para MEF
"""
import numpy as np
import copy
import pdb



def resolvermef(r, s, K, us, fr, case):
    """
    U, F = resolvermef(r,s,K,us,fr)

    resuelve el problema de MEF dados los indices de gl incognitas r , y los indices de gl
    vinculados s. arma la ecuación reducida y la resuelve usando numpy.linalg.solve.

    Ur = np.linalg.solve(K[ ix_(r,r) ],  fr - K[ix_(r,s)].dot(us))
    Fs = K[ ix_(s,:) ].dot(U)

    # equivalente a : 

    # U(r) = K_rr ^-1 *( fr - K_rs u_s )

    devuelve el vector U y F armados , U[s] = us, U[r] = Ur , F[s] = Fs, F[r]  = fr

    case es un string para identificar el caso
    """
    N = len(K)
    nvin = len(s)
    ninc = len(r)
    ur = np.zeros([ninc, 1])
    fs = np.zeros([nvin, 1])
    U = np.zeros([N, 1])
    F = np.zeros([N, 1])
    Kred = K[np.ix_(r, r)]
    Kvin = K[np.ix_(r, s)]
    Kf = K[ s, :]
    B = fr - Kvin.dot(us)
    pdb.set_trace()
    Ur = np.linalg.solve(Kred, B)
    U[r] = copy.copy(Ur)
    U[s] = copy.copy(us)
    fs = Kf.dot(U)
    F[r] = copy.copy(fr)
    F[s] = copy.copy(fs)
    np.savetxt(case+'Forces.dat', F)
    np.savetxt(case+'Displace.dat', F)
    return U, F


def ensamble(MC, MN, gl, etype):
    """ 
    esta función ensambla los elementos indicados por el argumento etype.

    """
    pdb.set_trace()
    kel = kelemental(etype)
    # numero de nodos
    N = len(MN)*gl
    # inicio la matriz global de rigidez
    Kglob = np.zeros([N, N])
    # numero de elementos y de nodos por elemento
    ne, nnxe = np.shape(MC)
    # esta linea es necesaria porque en python los indicesvan desde cero
    MCinds = MC - 1
    for e in range(ne):
        kele = kel
        for i in range(nnxe):
            ni = MCinds[e, i]
            rangei = np.linspace(i*gl, (i+1)*gl-1, gl).astype(int)
            rangeni = np.linspace(ni*gl, (ni+1)*gl-1, gl).astype(int)
            for j in range(nnxe):
                nj = MCinds[e, j]
                rangej = np.linspace(j*gl, (j+1)*gl-1, gl).astype(int)
                rangenj = np.linspace(nj*gl, (nj+1)*gl-1, gl).astype(int)
                # atención ahora:
                # ver formulas de apunte de ensamble de matrices
                print(e, rangeni, rangenj)
                # print(e, rangei, rangej)
                # pdb.set_trace()
                pdb.set_trace()
                Kglob[np.ix_(rangeni, rangenj)] += kele[np.ix_(rangei, rangej)]
    return Kglob


def kelemental(etype):
    """ arma la matriz elemental segun etype

    etype == 1: resortes unimensionales [ 1 -1 , -1 1]
    """
    return np.array([[1, -1],[-1, 1]], dtype=float)
