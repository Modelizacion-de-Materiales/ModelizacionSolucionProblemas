import numpy as np
import matplotlib.pyplot as plt
import tycc
import valcc
import geo
#import MakeA as lib
import time
import pdb

def get_val_cc(typecc: dict, valcc: dict):
    if len(set(typecc.values())) == 1: # all conditions are the same
        return np.mean(list(valcc.values()))

def get_cases_tycc(cases: str, tycc: dict):
    return {key: val for key, val in tycc.items() if key in cases}

def get_cases_valcc(cases: str, valcc: dict):
    return get_cases_tycc(cases, valcc)

class Chapa:
    
    def __init__(self, Nx, Ny, tycc, valcc):
        self.Nx = Nx
        self.Ny = Ny
        self.tycc = tycc
        self.valcc = valcc
        self.Nk = Nx*Ny
        self.vertices = {'ab': 0,'bc':  self.Nx-1,'ad':  self.Nk-Nx, 'cd':  self.Nk-1} 
        self.Nodes = np.linspace(0, self.Nk-1, self.Nk)
        self.beta = self.Ny / self.Nx

    def get_borders_indexes(self):
        #  borde de abajo
            kb = np.linspace(self.vertices['ab'],  self.vertices['bc'], self.Nx).astype(int)
        # borde de arriba
            kd = np.linspace(self.vertices['ad'],  self.vertices['cd'], self.Nx).astype(int)
        # borde de la izquierda
            ka = np.linspace(self.vertices['ab'],  self.vertices['ad'], self.Ny).astype(int)
        # borde de la derecha
            kc = np.linspace(self.vertices['bc'],  self.vertices['cd'], self.Ny).astype(int)
            self.bordes = {'a':ka, 'b': kb, 'c':kc, 'd': kd}
    
    #TODO: implement cc de flujo !
    def get_AB(self):
        
        if not hasattr(self, 'bordes'):
            raise Exception('no estan definidos los bordes')
        if not hasattr(self, 'vertices'):
            raise Exception('no estan definidos los vertices')
        
        A = np.identity(self.Nk)
        beta = self.beta
        beta2 = beta**2
        B = np.zeros((self.Nk,1))
        vertices = self.vertices
        allbordes = np.hstack(list(self.bordes.values()))

        for vertcases, vertindex in vertices.items():
            B[vertindex] = get_val_cc(get_cases_tycc(vertcases, self.tycc),get_cases_valcc(vertcases, self.valcc))

        for bordecase, bordeindexes in self.bordes.items():
            B[bordeindexes[1:-1]] = get_val_cc(get_cases_tycc(bordecase, self.tycc),get_cases_valcc(bordecase, self.valcc))

        for k, fila in enumerate(A):
            if k not in allbordes:
                fila[[k-self.Nx, k-1, k, k+1, k+self.Nx]] = [beta2, 1, -2*(beta+1), 1, beta2] 

        self.A = A
        self.B = B
        
    def msolve(self):
    #  Solucion
        if hasattr(self, 'A'):
            to = time.time()
            self.T = np.linalg.solve(self.A, self.B)
            dt = time.time()-to
            return self.T, dt
        else:
            raise ValueError('Usted no ha armado la matríz todavía')


    def maketmat(self):
        if hasattr(self, 'T'):
            return self.T.reshape(self.Nx, self.Ny)
        else:
            raise ValueError('Usted no ha resuelto el sistema todavía')


def makeplots(myTmat, mygeo, case, fig=None, ax=None):
    x = np.linspace(0, mygeo.Lx, geo.Nx).astype(float)
    y = np.linspace(0, mygeo.Ly, geo.Ny).astype(float)
    X, Y = np.meshgrid(x, y)
    
    if fig is None:
        fig, ax = plt.subplots(1,1)

    CS = ax.contourf(X, Y, myTmat)
    CS2 = ax.contour(CS, levels=CS.levels, colors='k') #, linewidth=5)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    cbar = plt.colorbar(
            CS,
            ticks=np.linspace(np.min(np.min(myTmat)),
                np.max(np.max(myTmat)),
                10).astype(int),
            #boundaries=[np.min(np.min(myTmat)), np.max(np.max(myTmat))]
            )
    cbar.ax.set_ylabel('Temperature')
    ax.set_title(case)
    fig.savefig('Temps-'+case+'.pdf')

    return x, y, fig, ax


def makeFlujos(myTmat, myx, myy, case, fig=None, ax = None):
    dTy,  dTx = lib.migrad(myTmat)
    X, Y = np.meshgrid(myx, myy)
    if fig is None:
        fig , ax = plt.subplots()
    ax.streamplot(X, Y, -dTx, -dTy, color='k', linewidth=3, density=1)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')

    fig.savefig('Temps-'+case+'-Flujos.pdf')

    return dTx, dTy


def main():
    """
    Este módulo Python resuelve el problema 1 de la guia.
    Funciones:

    main() : llamado a las funciones de los distintos pasos ,
    con opciones por omisión

    makeFlujos(myTmat, myx, myy, case)
    construye los flujos, retorna  dTx, dTy

    maketmat(T, mygeo)
    pasa del vector temp a la matriz temp, devuelve mtTmat

    makeplots():
    como su nombre lo indica, construye los gráfcos con el nombre de 'case'
    indicado
    """
    T, dt = makensolve(geo, tycc, valcc)
    Tmat = maketmat(T, geo)

    x, y, fig, ax = makeplots(Tmat, geo, tycc.abajo)
    dTy, dTx = makeFlujos(Tmat, x, y, tycc.abajo, fig=fig, ax=ax)


def escaleo():
    """
    esta función calcula los tiempos para resolver el problema 
    ( para invertir la matriz )
    llama a makemat y makeplot
    guarda Temps-case.dat
    """
    Nx = 3**np.linspace(2.5, 4, 10)
    Nx = Nx.astype(int)
    t = []
    filetiempos = open('tabla-tiempos.dat','w')
    for size in Nx:
        geo.Nx = size
        geo.Ny = size
        case = '{:03d}'.format(size)
        T, dt = makensolve(geo, tycc, valcc)
        t.append(dt)
        print(case, dt)
        Tmat = maketmat(T, geo)
        np.savetxt('Temps-'+case+'.dat', Tmat)
        x, y = makeplots(Tmat, geo, case)
        filetiempos.write('{:d}  {:10e} \n'.format(size, dt))
    filetiempos.close()


def fitescaleo(datafile):
    n, dt = np.loadtxt(datafile, unpack=True)
    x = np.log(n)
    y = np.log(dt)
    m, b = np.polyfit(x, y, 1)
    plt.plot(x, y, 'ok')
    plt.plot(x, m*x+b, '--k')
    plt.xlabel(r'$log(N)$')
    plt.ylabel(r'$log(t)$')
    plt.show()
    plt.savefig('fitescaleo.pdf')


def plotchapa(tempsfile):
    Tmat = np.loadtxt(tempsfile)
    geo.Nx, geo.Ny = np.shape(Tmat)
    case = '{:03d}x{:03d}'.format(geo.Nx, geo.Ny)
    makeplots(Tmat, geo, case)


if __name__ == "__main__":
    main()
