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


def get_randoms(nx: int, ny: int, lengths: int=1000):
    """
    Returns
    =======
    randoms, flipi, flipj
    """
    np.random.seed(16)
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
    nodirectflip = 0
    sidirectflip = 0
    siflip = 0
    noflip = 0
    e = magnet.get_total_energy()
    m = magnet.get_magnetic_moment()
    eacum = e
    Mabsacum = abs(m)
    Macum = m
    e2acum = e**2
    M2acum = m**2
    for r, i, j in zip(randoms, flipi, flipj):
        flip = False
        de = magnet.get_total_echange_onflip(i,j)
        dm = magnet.get_mchange_onflip(i, j)
        if de < 0:
            sidirectflip +=1
            flip = True
        elif r < np.exp(-de/T):
            nodirectflip +=1
            siflip +=1
            flip = True
        else:
            nodirectflip += 1
            noflip +=1
        if flip == True:
            magnet.flipthespin(i,j)
            e += de
            m += dm
        eacum += e
        e2acum += e**2
        Macum += m
        Mabsacum += abs(m)
        M2acum += m**2
    results = {'T': T, 'Emean': eacum / nsteps, 'E2mean': e2acum/nsteps, 'Mmean': Macum/nsteps, 'MabsMEAN': Mabsacum/nsteps, 'M2acum': M2acum / nsteps}
    return magnet, pd.Series(results) #eacum/nsteps, siflip, noflip, sidirectflip, nodirectflip

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



