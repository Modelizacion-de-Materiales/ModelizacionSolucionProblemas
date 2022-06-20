import numpy as np
import pandas as pd

class Magnet:

    def __init__(self, s: np.ndarray = None,  Nx: int =2, Ny: int =2, J:float = 1.):

        if s is None:
            self.s = np.random.randint(0,1,size=[Nx, Ny])*2-1
        else:
            if type(s) is not np.ndarray:
                self.s = np.array(s)
            else:
                self.s = s
        self.Nx, self.Ny = self.s.shape
        self.N = self.Nx*self.Ny
        self.J = J

    def get_magnetic_moment(self):
        self.moment = self.s.sum()
        return self.moment

    def get_total_energy(self):
        neigboursup = np.roll(self.s, [-1, 0])
        neigboursri = np.roll(self.s, [0, -1])
        neigboursdn = np.roll(self.s, [1, 0])
        neigboursle = np.roll(self.s, [0, 1])
        espin = -(self.J/2)*self.s*(neigboursup + neigboursdn + neigboursle+ neigboursri)
        self.E = espin.sum()
        return self.E        

    def flipthespin(self, i, j):
        self.s[i,j] *= -1

    def get_total_echange_onflip(self, i, j):
        sumofneighbours =  self.s[i-(self.Nx-1), j]  + self.s[i-1, j] + self.s[i, j - (self.Ny-1)]+ self.s[i, j -1]
        de = (-self.J)*(-2*self.s[i, j])*sumofneighbours
        return de

    def get_mchange_onflip(self, i,j):
        return -2*self.s[i,j]

class SolucionTeorica2x2:

    def __init__(self, beta, J):
        self.N = 4
        self.beta = beta
        self.J = J
        self.Z = 2*np.exp(8*self.beta*self.J) + 12 + 2*np.exp(-8*self.beta*self.J)

    def emean(self):#, beta):
        return (-1/self.Z) * (2*8*np.exp(8*self.beta)+2*(-8)*np.exp(-8*self.beta))/4
    
    def e2mean (self):
        return (1/self.Z)*(2*64*np.exp(8*self.beta) + 2*64*np.exp(-8*self.beta))/4

    def mmean (self):
        return (1/self.Z) * (2*4*np.exp(8*self.beta) + 8*2)/4

    def m2mean(self):
        return (1/self.Z)*(2*16*np.exp(8*self.beta) + 8*4)/4




def get_randoms(nx: int, ny: int, lengths: int=1000):
    """
    Returns
    =======
    randoms, flipi, flipj
    """
    np.random.seed(20130307)
    randoms = np.random.rand(lengths)
    flipi = np.random.randint(nx, size=lengths) 
    flipj = np.random.randint(ny, size=lengths) 
    return randoms, flipi, flipj


def termalize(magnet: Magnet, nsteps: int = 1000, T: float=1e-2) -> pd.core.series.Series:
    """
    Retruns
    =======
    magnet, results
    """
    Nx, Ny = magnet.Nx, magnet.Ny
    randoms, flipi, flipj = get_randoms(Nx, Ny, lengths=nsteps)
    e = magnet.get_total_energy()
    m = magnet.get_magnetic_moment()
    eacum = e
    Mabsacum = abs(m)
    Macum = m
    e2acum = e**2
    M2acum = m**2
    for r, i, j in zip(randoms, flipi, flipj):
        de = magnet.get_total_echange_onflip(i,j)
        dm = magnet.get_mchange_onflip(i, j)
        if test_flip(de, T, p = r):
            magnet.flipthespin(i,j)
            e += de
            m += dm
        eacum += e
        e2acum += e**2
        Macum += m
        Mabsacum += abs(m)
        M2acum += m**2
    results = {
            'T': T,
            'Emean': eacum / nsteps /magnet.N, 
            'E2mean': e2acum/nsteps/magnet.N,
            'Mmean': Macum/nsteps/magnet.N,
            'MabsMEAN': Mabsacum/nsteps/magnet.N, 
            'M2acum': M2acum / nsteps / magnet.N, 
            'CV' : ( e2acum/nsteps - ( eacum/nsteps )**2 )/T**2/magnet.N,
            'X' : ( M2acum/nsteps - ( Macum/nsteps )**2 )/T/magnet.N,
            'Xp' : ( M2acum/nsteps - ( Mabsacum/nsteps )**2 )/T/magnet.N,
            }
    return magnet, pd.Series(results) #eacum/nsteps, siflip, noflip, sidirectflip, nodirectflip

def test_flip(de, T, p=None):
    if p is None:
        p = np.random.rand()
    flip = False
    if de < 0:
        flip = True
    elif p < np.exp(-de/T):
        flip = True
    return flip

def main(sizes = [2], mcsteps = [1e4] ):
    from tqdm.auto import tqdm
    import pdb
    import os
    T = np.linspace(6, 0.5, 50)
    beta = 1/T
    results = {s: {} for s in sizes}
    for nsteps in mcsteps:
        for size, thisresult in results.items():
            filename = f'results_{size}x{size}_{nsteps}.dat'
            if os.path.exists(filename):
                continue
            else:
                magnet = Magnet(Nx = size, Ny=size)
                progress = tqdm(T)
                for t in progress:
                    progress.set_description(filename)
                    magnet, resultdict = termalize(magnet, T = t, nsteps = int(nsteps))
                    thisresult.update({t: resultdict})
                result_df = pd.DataFrame.from_dict(thisresult, orient='index')
                result_df.to_csv(filename, index=None)


if __name__ == '__main__':
    main()



