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
    N = len (K)
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
    np.savetxt(case+'Forces.dat',F)
    np.savetxt(case+'Displace.dat',F)
    return U, F
