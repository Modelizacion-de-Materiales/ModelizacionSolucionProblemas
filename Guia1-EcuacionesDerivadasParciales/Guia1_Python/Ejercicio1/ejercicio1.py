import numpy as np
import pdb

def getcasedict(name, dictarray):
    result = {thisname: thisval for thisname, thisval in dictarray.items() if thisname in name}
    return result

def getvalcc(valcc, tycc):
    if len(set(tycc.values())) == 1: # all the tycc are equal
        return np.mean(list(valcc.values()))
    elif 'temp' in tycc.values():
        valkeys = [key for key, val in tycc.items() if val=='temp'][0]
        return valcc[valkeys]

class Chapa:

    def __init__(self, Nx, Ny, tycc, valcc,  Lx=1, Ly=1):
        self.Nx = Nx
        self.Ny = Ny
        self.Nk = Nx*Ny
        self.tycc = tycc
        self.valcc = valcc
        self.beta = self.Ny / self.Nx
        
    def makeborders(self):

        if not hasattr(self, 'Nx'):
            raise ValueError('aún no a definido la geometría')

        self.border = {
                'a': np.linspace(0, self.Nk-self.Nx, self.Ny).astype(int),
                'b': np.linspace(0, self.Nx-1, self.Nx).astype(int),
                'c': np.linspace(self.Nx-1, self.Nk-1, self.Ny).astype(int),
                'd': np.linspace(self.Nk - self.Nx, self.Nk-1, self.Nx).astype(int)
                }

    def makevertices(self):

        if not hasattr(self, 'border'):
            raise ValueError('aún no ha definido los border')

        self.vertice = {
                'ab': np.intersect1d(self.border['a'], self.border['b']),
                'bc':  np.intersect1d(self.border['c'], self.border['b']),
                'cd':  np.intersect1d(self.border['c'], self.border['d']),
                'ad':   np.intersect1d(self.border['a'], self.border['d'])
                }

    def makematrix(self):

        if not hasattr(self, 'border'):
            raise ValueError('aún no ha definido los border')
        if not hasattr(self, 'vertice'):
            raise ValueError('aún no ha definido los vertices')

        M = np.identity(self.Nk)
        B = np.zeros((self.Nk, 1))
        beta = self.beta
        beta2 = beta**2

        allborders = np.unique(np.hstack(list(self.border.values())))

        for vertname, k in self.vertice.items():
            B[k] = getvalcc(getcasedict(vertname, self.valcc), getcasedict(vertname, self.tycc))

        for bordename, kvec in self.border.items():
            thisvalcc = getcasedict(bordename, self.valcc)
            thistycc = getcasedict(bordename, self.tycc)
            B[kvec[1:-1]] = getvalcc( thisvalcc, thistycc)
            if 'flujo' in thistycc.values():
                if 'a' in bordename:
                    for k in kvec[1:-1]:
                        M[k, [k-self.Nx, k, k+1, k+self.Nx]] = np.array([beta2, -2*(beta+1), 2, beta2])
                elif 'b' in bordename:
                    for k in kvec[1:-1]:
                        M[k, [k-1, k, k+1, k+self.Nx]] = np.array([1, -2*(beta+1), 1, 2*beta2])

        for k, fila in enumerate(M):
            if k not in allborders:
                fila[[ k-self.Nx, k-1, k, k+1, k+self.Nx ]] = np.array([beta2, 1, -2*(1+beta), 1, beta2])

        self.B = B
        self.M = M

    def msolve(self):
        import time
        if not hasattr(self, 'M'):
            raise ValueError('no se ha definido la matriz del sistema')
        t1 = time.time()
        self.T = np.linalg.solve(self.M, self.B)
        t2 = time.time() - t1
        return self.T, t2 - t1









