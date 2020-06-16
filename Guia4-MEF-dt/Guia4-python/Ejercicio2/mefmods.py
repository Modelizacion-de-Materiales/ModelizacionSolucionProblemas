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
import matplotlib.pyplot as plt
np.set_printoptions(precision=4, linewidth=120)


#U, F = mef.resolvermef(R, S, K, US, FR, 'puente')
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
    np.savetxt(case+'Forces.dat', F, fmt='%.4e')
    np.savetxt(case+'Displace.dat', U, fmt='%.4e')
    return U, F


def ensamble(MC, MN, MP, gl, ETYPES, case=''):
    """
    esta función ensambla los elementos indicados por el argumento etype.
    """
    # numero de nodos
    N = len(MN)*gl
    Kglob = np.zeros([N, N])
    ne, nnxe = np.shape(MC)
    # esta linea es necesaria porque en python los indicesvan desde cero
    fo = open('MatricesElementales-'+case+'.dat', 'w')
    for e in range(ne):
        MCloc = MC[e, :]  # el -1 va parapasar a indices
        MNloc = MN[MCloc, :]
        if isinstance(ETYPES[e], str):
            kele = melemental(ETYPES[e], MP[e, :], MNloc, MCloc)
        else:
            kele = kelemental(ETYPES[e], MP[e, :], MNloc, MCloc)
        scale = np.max(np.max(kele))
        fo.write('Elemento {:d}, scale = {:e}\n'.format(e, scale))
        fo.write('{}\n'.format(kele/scale))
        for i in range(nnxe):
            ni = MCloc[i]
            rangei = np.linspace(i*gl, (i+1)*gl-1, gl).astype(int)
            rangeni = np.linspace(ni*gl, (ni+1)*gl-1, gl).astype(int)
            for j in range(nnxe):
                nj = MCloc[j]
                rangej = np.linspace(j*gl, (j+1)*gl-1, gl).astype(int)
                rangenj = np.linspace(nj*gl, (nj+1)*gl-1, gl).astype(int)
                Kglob[np.ix_(rangeni, rangenj)] = Kglob[np.ix_(rangeni, rangenj)]+\
                        kele[np.ix_(rangei, rangej)]
    scale = np.max(np.max(Kglob))
    Kglob[abs(Kglob/scale) < 1e-9] = 0
    fo.write('\n\nMatriz Global , scale factor = {:e}\n'.format(scale))
    fo.write('{}\n'.format(Kglob/scale))
    fo.write('\n su determinante: {:e}'.format(np.linalg.det(Kglob/scale)))
    fo.close()
    return Kglob

def melemental(etype, MP, NODES=None, CONEC=None):
    """
    arma matrices de masas elementales segun etype
    etype:
    = "long" , matrices de masa para movimiento longitudinal
    = "trans" , matrices de masa para movimiento transversal
    """
    if etype == "long":
        L = np.abs(np.diff(NODES[:, 0]))
#        mel = np.array([[2., 1.], [1., 2.]]) * MP[0]*MP[1] / 6.
        mel = np.array([[2., 1.], [1., 2.]]) * MP.prod()*L / 6.
    elif etype=="long_lump":
        L = np.abs(np.diff(NODES[:, 0]))
        mel = np.array([[1., 0.], [0., 1.]]) * MP.prod()*L / 2.
    elif etype == "trans":
        L = np.abs(np.diff(NODES[:, 0]))[0]
        mel = np.array([
            [156., 22.*L, 54., -13.*L ],
            [22.*L, 4.*L**2, 13.*L, -3*L**2],
            [54, 13*L, 156, -22*L],
            [-13*L, -3*L**2, -22*L, 4*L**2]
            ]) * MP.prod()*L / 420.
    elif etype == "trans_lump":
        L = np.abs(np.diff(NODES[:, 0]))
        mel = np.array(
                [[12., 0., 0., 0], [0, L**2, 0., 0.],
                    [0.,  0.,  12., 0.], [0., 0., 0., L**2]],
                dtype=float
                )*(MP.prod()*L / 24.)
    return mel


def kelemental(etype, MP, NODES=None, CONEC=None):
    """ arma la matriz elemental segun etype

    etype == 1: resortes unimensionales [ 1 -1 , -1 1]
    """
    if etype == 0:  # caso etype =resortes
        L = np.linalg.norm(np.diff(NODES[:, 0]))
        kel = MP.prod()*np.array([[1, -1], [-1, 1]], dtype=float)/L
    elif etype == 1:  # caso etipe = barras 
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
        c = cos(THETA)
        s = sin(THETA)
        R = np.array([[c, s], [-s, c]])
        T1 = np.hstack((R, np.zeros((2, 2))))
        T2 = np.hstack((np.zeros((2, 2)), R))
        T = np.vstack((T1, T2))
        k = np.array([[1., 0., -1., 0.], [0., 0., 0., 0.], [-1., 0., 1., 0.], [0., 0., 0., 0.]])
        kel = (MP.prod()/L)*((T.T).dot(k)).dot(T)
        # algunas veces los cos y sin dan valores muy bajos. entonces:
        tol = 1e-8
        kel[abs(kel) < tol] = 0.0
    elif etype == 3:  # barras unidimensionales con torsion
        kel = np.zeros((4, 4))
        X = NODES[:, 0]
        dx = np.diff(X)
        L = sqrt(dx**2)
        kel = (MP.prod()/L**3) * np.array(
                [[12, 6*L, -12, 6*L],
                    [6*L, 4*L**2, -6*L, 2*L**2],
                    [-12, -6*L, 12, -6*L],
                    [6*L, 2*L**2, -6*L, 4*L**2]]
                )
    elif etype == 2:  # triángulos de 2gl por nodo
        # Xinv = np.linalg.inv(X) / (2*A)
        # alpha = Xinv[0]
        # beta = Xinv[1]
        # gamma = Xinv[2]
        t = MP[0] # espesor
        nu = MP[1] # modulo de poison
        E = MP[2] # modulo de elasticidad
        D = E * np.array([[1, nu, 0.], [nu, 1., 0.], [0., 0., 0.5*(1-nu)]]) / (1 - nu**2)
        B, A = makeB(NODES, CONEC) 
        kel = t*abs(A)*B.T.dot(D.dot(B))
    return kel
    
def makeB(MNloc, MCloc):
        X = np.hstack((np.ones((3, 1)), MNloc[:, 0:2]))
        A = 0.5 * np.linalg.det(X)
        x = MNloc[:, 0]
        y = MNloc[:, 1]
        alpha = [x[1]*y[2] - x[2]*y[1], x[0]*y[2] - x[2]*y[0], x[0]*y[1] - x[1]*y[0]]
        beta = [y[1] - y[2], y[2] - y[0], y[0] - y[1]]
        gamma = [x[2] - x[1], x[0] - x[2], x[1] - x[0]]
        B = (1/(2*A))*np.array(
                [
                    [beta[0], 0., beta[1], 0, beta[2], 0],
                    [0., gamma[0], 0., gamma[1], 0., gamma[2]],
                    [gamma[0], beta[0], gamma[1], beta[1], gamma[2], beta[2]]
                    ]
                )
        return B, A

def getstress(MESH, MP,  U):
    sigma = np.zeros((len(MESH.MC), 3))
    for e in range(len(MESH.MC)):
        B, A = makeB(MESH.MN[MESH.MC[e]-1], MESH.MC[e])
        nu = MP[e, 1]  # modulo de poison
        E = MP[e, 2]  # modulo de elasticidad
        D = E * np.array([[1, nu, 0.], [nu, 1., 0.], [0., 0., 0.5*(1-nu)]]) / (1 - nu**2)
        Uloc = []
        for n in MESH.MC[e]:
            Uloc = np.append(Uloc, U[(n-1)*MESH.GL:(n-1)*MESH.GL+1+1])
        sigma[e] = ((D.dot(B)).dot(Uloc)).T
    return sigma


def getgeo(filename):
    # fi = open(filename,'r')
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
                ELTYPES = np.zeros((NELEM, 1), dtype=int)
                # Matriz de propiedades, inicio para 2 propiedades, luego corrijo
                MP = np.zeros((NELEM, 2), dtype=float)
                for i in range(NELEM):
                    thiselem = np.fromstring(
                            fi.readline().strip(), sep=' '
                            )
                    ELTYPES[i, :] = thiselem[0]
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
    return GL, MC, MN, MP, ELTYPES, (IVIN, MVIN)


def makevins(GL, NNODES, LVIN):
    """
    lee la lista de vinculos y lo transforma en los vectores r y s, us y fr
    """
    r = np.empty((0, 1), dtype=int)
    fr = np.empty((0, 1), dtype=float)
    s = np.empty((0, 1), dtype=int)
    us = np.empty((0, 1), dtype=float)
    IVIN, MVIN = LVIN
    for n in range(NNODES):
        if n in (IVIN[:, 0]):
            # el tema de usar np.where es que devuelve un array con todas las 
            # coincidencias por fila. Yo se que la coincidencia va a ser única, por
            # lo que puedo tomar el primer elemento del primer array
            thevin = np.where(IVIN[:, 0] == n)[0][0]
            node, dirs = IVIN[thevin, 0], IVIN[thevin, 1:]
            for v in range(len(dirs)):
                if dirs[v] > 0:
                    s = np.append(s, node*GL+v)
                    us = np.vstack((us, MVIN[thevin, v]))
                else:
                    r = np.append(r, [node*GL+v])
                    fr = np.vstack((fr, MVIN[thevin, v]))
        else:
            r = np.append(r, np.linspace(n*GL, (n+1)*GL-1, GL, dtype=int))
            fr = np.vstack((fr, np.zeros((GL, 1), dtype=float)))
    return r, s, us, fr


def mkbound(MESH, BOUNDARY, TYPES,  VALUES):
    """ 
    usa definición de elementos lineales para armar las correspondientes 
    condiciones de vínculo

    parametros
    =====================
    boundary : matriz de conectividad para los elementos de borde
    types: tipo de condicion de contorno
    values: valores de las condiciones de contorno

    returns:
    r, s, us, fr
    """
    r = np.empty((0, 1), dtype=int)
    s = np.empty((0, 1), dtype=int)
    us = np.empty((0, 1), dtype=float)
    fr = np.empty((0, 1), dtype=float)
    f = np.zeros((len(MESH.MN)*MESH.GL, 1))
    for n in range(len(MESH.MN)):
        if (n == BOUNDARY[0]-1).any():
            for g in range(MESH.GL):
                s = np.append(s, n*MESH.GL + g)
                us = np.append(us, VALUES[0])
                np.append(us, 0)
        else:
            for g in range(MESH.GL):
                r = np.append(r, int(n*MESH.GL+g))
    for e in range(len(BOUNDARY[1])):
        N1 = BOUNDARY[1][e,0]-1
        N2 = BOUNDARY[1][e,1]-1
        Y = MESH.MN[[N1, N2], 1]
        L = abs(np.diff(Y))
        f[[2*N1, 2*N2]] += np.ones((2, 1))*VALUES[1]*L / 2
    fr = f[r].reshape(-1,1)
    us = us.reshape(-1,1)
    return r, s, us, fr


### Matrices de desplazamientos
##################################################

def makenodex(X, GL, DIM, NNODOS):
    """
    convierte una cantidad vectorial X en la respectiva 
    matriz de vectores para esos nodos.
    Por ejemplo, para los desplazamientos D = [ D1X, D1Y , D2X, D2Y, ... ]
    devuelve:
    MD = [ [ D1X, D1Y ],
           [ D2X, D2Y ],
           ]
    """
    MX = np.zeros((NNODOS, GL))
    for i in range(NNODOS):
        rangei = np.linspace(i*GL, (i+1)*GL-1, GL, dtype=int)
        MX[i, :] = X[rangei].reshape(1,GL)
    return MX


# ## Funciones de Interpolacion
#################################################


def NL1DA(x, L):
    """
    Función de interpolación Lineal Unidimensional
    NL1DA (x,L ) = (1-x)/L
    NL1DA(0,L) = 1,
    NL1DA(L,L) = 0,
    """
    return (1.-x)/L


def NL1DB(x, L):
    """
    Función de interpolación Lineal
    NL1DA (x,L ) = x/L
    NL1DA(0,L) = 0,
    NL1DA(L,L) = 1,
    """
    return x/L

def NT1(x, L):
    """
    Funcion de interpolación Lineal Para Torsión
    NT1(x,L) = (1/L**3) *( 2*x**3 - 3*x**2*L + L**3)
    """
    return (1/L**3)*(2*x**3 - 3*L*x**2 + L**3)

def NT2(x, L):
    """
    Funcion de interpolación Lineal Para Torsión
    NT2(x,L) = (1/L**3) *(1/L**3)*(L*x**3-2*L**2*x**2+x*L**3)
    """
    return (1/L**3)*(L*x**3-2*(L**2)*(x**2)+x*(L**3))


def NT3(x, L):
    """
    Funcion de interpolación Lineal Para Torsión
    NT3(x,L) = (1/L**3) *( 2*x**3 - 3*x**2*L + L**3)
    """
    return (1/L**3)*(-2*x**3+3*L*x**2)


def NT4(x, L):
    """
    Funcion de interpolación Lineal Para Torsión
    NT3(x,L) = (1/L**3) *( 2*x**3 - 3*x**2*L + L**3)
    """
    return (1/L**3)*(L*x**3-L**2*x**2)


# ## Graficar el mallado, inicial y final
def plotmesh(MC, MN, MF, MD,  case, scale=100):
    """ 
    Grafica el mallado original y luego desplazado, 
    requiere tener la matriz de nodos  , la matriz de desplzamientos y 
    la matriz de fuerza
    inputs:
    MC matriz de conectividad
    MN Matriz de nodos
    MF matriz de fuerzas 
    MD Matriz de desplazamientos
    case string con nombre de caso
    
    opcional
    scale: factor de escala para el dibujo
    """
    NEL, NNXEL = np.shape(MC)
    # grafico la  matriz de nodos desplazada
    fig, ax = plt.subplots()
    plt.title(case)
    # ax.use_sticky_edges = False
    ax.margins(0.1)
    for e in range(len(MC)):
        X = np.reshape(MN[MC[e, :], 0], (NNXEL, 1))
        Y = np.reshape(MN[MC[e, :], 1], (NNXEL, 1))
        ax.plot(X, Y, '-ob', label='Estructura Inicial')
    handles, labels = ax.get_legend_handles_labels()
    display = [len(MC)-1, len(MC)-1+len(MN)]
    ax.legend([handle for i, handle in enumerate(handles) if i==len(MC)-1],
            [label for i, label in enumerate(labels) if i==len(MC)-1])
    fig.savefig(case+'Inicial.pdf')
    for e in range(len(MC)):
        X2 = MN[MC[e, :], 0]+scale*MD[MC[e, :], 0]  # np.reshape(MN[MC[e, :], 0], (NNXEL, 1))
        Y2 = MN[MC[e, :], 1]+scale*MD[MC[e, :], 1]  # np.reshape(MN[MC[e, :], 1], (NNXEL, 1))
        ax.plot(X2, Y2, '-or', label='Estructura Cargada')
    ax.quiver(
            MN[:, 0] + scale*MD[:, 0],
            MN[:, 1] + scale*MD[:, 1],
            MF[:, 0],
            MF[:, 1],
            label='Fuerzas'
            )
    plt.title('Desplazamientos x{}'.format(scale))
    handles, labels = ax.get_legend_handles_labels()
    display = [len(MC)-1, len(MC)-1+len(MN), len(labels)-1]
    ax.legend([handle for i, handle in enumerate(handles) if i in display],
            [label for i, label in enumerate(labels) if i in display])
    fig.savefig(case+'Final.pdf')
    plt.close()
    return

