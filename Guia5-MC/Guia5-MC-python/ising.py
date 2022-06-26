import numpy as np
import pandas as pd
import pdb
import copy

class Magnet(object):

    def __init__(self, s: np.ndarray = None,  Nx: int =2, Ny: int =2, J:float = 1.):

        if s is None:
            self.s = np.random.randint(0,2,size=[Nx, Ny])*2-1
        else:
            if type(s) is not np.ndarray:
                self.s = np.array(s)
            else:
                self.s = s
        self.Nx, self.Ny = self.s.shape
        self.N = self.Nx*self.Ny
        self.J = J
        self.E = self.get_total_energy()
        self.moment = self.get_magnetic_moment()

    def get_magnetic_moment(self):
        self.moment = self.s.sum()
        return self.moment

    def get_total_energy(self):
        E = 0
        for i in range(self.Nx-1, -1, -1):
            for j in range(self.Ny-1, -1, -1):
                E += -(self.J)*self.s[i,j]*(self.s[i-1, j]+self.s[i, j-1])
        return E

    def flipthespin(self, i, j):
        self.s[i,j] *= -1

    def get_total_echange_onflip(self, i, j):
        sumofneighbours =  self.s[i-(self.Nx-1), j]  + self.s[i-1, j] + self.s[i, j - (self.Ny-1)]+ self.s[i, j -1]
        de = (-self.J)*(-2*self.s[i, j])*sumofneighbours
        return de

    def update(self, de:float, dm:float, flip: list[ int ]) -> None:
        self.flipthespin(*flip)
        self.update_energy(de)
        self.update_mmoment(dm)

    def get_mchange_onflip(self, i,j):
        return -2*self.s[i,j]

    def update_energy(self, de:float)->None:
        self.E += de

    def update_mmoment(self, dm:float)->None:
        self.moment += dm
            

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


class Magnet_Stats(object):

    def __init__(self, magnet: Magnet):
        self.eacum = magnet.get_total_energy()
        self.Mabsacum = abs(magnet.moment)
        self.Macum = magnet.moment
        self.e2acum = magnet.E**2
        self.M2acum = magnet.moment**2

    def update(self, magnet:Magnet):
        self.eacum += magnet.E
        self.Mabsacum += abs(magnet.moment)
        self.Macum += magnet.moment
        self.e2acum += magnet.E**2
        self.M2acum += magnet.moment**2

    def report_averages(self, magnet:Magnet, nsteps: int, T: float):
        results = {
                'T': T,
                'Emean': self.eacum / nsteps /magnet.N, 
                'E2mean': self.e2acum/nsteps/magnet.N,
                'Mmean': self.Macum/nsteps/magnet.N,
                'MabsMEAN': self.Mabsacum/nsteps/magnet.N, 
                'M2acum': self.M2acum / nsteps / magnet.N, 
                'CV' : ( self.e2acum/nsteps - ( self.eacum/nsteps )**2 )/T**2/magnet.N,
                'X' : ( self.M2acum/nsteps - ( self.Macum/nsteps )**2 )/T/magnet.N,
                'Xp' : ( self.M2acum/nsteps - ( self.Mabsacum/nsteps )**2 )/T/magnet.N,
                }
        return pd.Series(results)


def get_randoms(nx: int, ny: int, lengths: int=1000):
    """
    Returns
    =======
    randoms, flipi, flipj
    """
#    np.random.seed()
    randoms = np.random.rand(lengths)
    flipi = np.random.randint(nx, size=lengths) 
    flipj = np.random.randint(ny, size=lengths) 
    return randoms, flipi, flipj

class MagnetDynamics(object):

    def __init__(self, magnet: Magnet):

        self.E = np.array([magnet.get_total_energy()])
        self.M = np.array([magnet.get_magnetic_moment()])
        self.s = [magnet.s]

    def update(self, magnet: Magnet):
        self.E = np.append(self.E, magnet.E)
        self.M = np.append(self.E, magnet.E)
        self.s.append(copy.copy(magnet.s))

    def get_values(self):
        return {'E': self.E, 'M': self.M, 's': self.s}


def termalize(magnet: Magnet, nsteps: int = 1000, T: float=1e-2, return_averages=True, return_dynamics=False) -> pd.core.series.Series:
    """
    Retruns
    =======
    magnet, results
    """
    Nx, Ny = magnet.Nx, magnet.Ny
    randoms, flipi, flipj = get_randoms(Nx, Ny, lengths=nsteps)
    if return_averages:
        magnetstats = Magnet_Stats(magnet)
    if return_dynamics:
        dynamics = MagnetDynamics(magnet)
    for r, i, j in zip(randoms, flipi, flipj):
        de = magnet.get_total_echange_onflip(i,j)
        dm = magnet.get_mchange_onflip(i, j)
        if test_flip(de, T, p = r):
            magnet.update(de, dm, [i, j])
        if return_averages:
            magnetstats.update(magnet)# 
        if return_dynamics:
            dynamics.update(magnet)
    results = magnet
    if return_averages:
        results = results, magnetstats.report_averages(magnet, nsteps, T)
    if return_dynamics:
        results = results, dynamics.get_values()
    return results

def test_flip(de, T, p=None):
    if p is None:
        p = np.random.rand()
    flip = False
    if de < 0:
        flip = True
    elif p < np.exp(-de/T):
        flip = True
    return flip


class animatedmagnet(object):


    def __init__(self, dynamics):
        import matplotlib.pyplot as plt

        self.S = dynamics['s']
        self.E = dynamics['E']
        self.nsteps = len(self.E)
        self.times = np.linspace(1, self.nsteps, self.nsteps).astype(int)

#    def init_movie(self):
        self.fig, self.ax = plt.subplots(1,2)
        self.ax[0].set_xticks([])
        self.ax[0].set_yticks([])
        self.ax[0].set_xticklabels([])
        self.ax[0].set_yticklabels([])
        self.ax[0].grid('on')
        self.ax[0].imshow(self.S[0])
        self.ax[1].set_xlim([0, self.nsteps])
        self.ax[1].set_ylim(np.min(dynamics['E'])/self.nsteps, np.max(dynamics['E'])/self.nsteps)
        self.ax[1].set_ylabel('E')
        self.ax[1].set_xlabel('time')
        self.Line,  = self.ax[1].plot(self.times, self.E/self.nsteps,linewidth=5, c='k')
        self.fig.tight_layout()
#        return [im, self.Line]

    def update(self, t:int):
#        self.Line.set_data(self.times[:t-1], self.E[:t-1])
        line,  = self.ax[1].plot(self.times[t-1], self.E[t-1]/self.nsteps,'o', markersize=10, color='r')
        im = self.ax[0].imshow(self.S[t-1], cmap='Greys')
        return [im, line]

    def animate(self):
        from matplotlib.animation import ArtistAnimation
        ims = []
        for t in self.times:
            ims.append(self.update(t))
        self.aniimation = ArtistAnimation(self.fig, ims,)


def cooldown(sizes = [2], mcsteps = [1e4] , TF = 6, T0 = 1):
    from tqdm.auto import tqdm
    import os
    T = np.linspace(TF, 1, 50)
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
                    magnet = termalize(magnet, T = t, nsteps=4000, return_averages=False)
                    magnet, resultdict = termalize(magnet, T = t, nsteps = int(nsteps))
                    thisresult.update({t: resultdict})
                result_df = pd.DataFrame.from_dict(thisresult, orient='index')
                result_df.to_csv(filename, index=None)


if __name__ == '__main__':
    main()



