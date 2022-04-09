import numpy as np
import pdb

def getcasedict(name, dictarray):
    result = {thisname: thisval for thisname, thisval in dictarray.items() if thisname in name}
    return result

def getvalcc(valcc, tycc):
    if len(set(tycc.values())) == 1:
        return np.mean(list(valcc.values()))

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
            B[kvec[1:-1]] = getvalcc(getcasedict(bordename, self.valcc), getcasedict(bordename, self.tycc))

        for k, fila in enumerate(M):
            if k not in allborders:
                fila[[ k-self.Nx, k-1, k, k+1, k+self.Nx ]] = np.array([beta2, 1, -2*(1+beta), 1, beta2])



        self.B = B
        self.M = M







