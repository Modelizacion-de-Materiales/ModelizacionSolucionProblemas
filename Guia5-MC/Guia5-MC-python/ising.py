import numpy as np
import numpy.random as rd
import pdb

class magnet(object):
    """
    2dimensional magnetic material of size NxNspins

    Atributes
    ========
    s: NxN array with the spin distributions
    """

    def __init__(self, N=2, J=1):
        self.s = rd.randint(2, size=(N, N))*2-1
        s = self.s
        self.J = J
        self.M = np.sum(np.sum(s))
        self.Eo = (J/2)*(
                s*(np.roll(s, 1, 0) + np.roll(s, -1, 0) + np.roll(s, 1, 1) + np.roll(s, -1, 1))
                ).sum()

    def termalize(self, kT=5, niter=10000):
        flip_index = rd.randint(self.s.shape[0], size=(niter, 2))
        s = self.s
        for i in range(niter):
            s, dE = ising.metropolis(self.s, kT,  flip_index[i])
        self.s = s

    def cool_down(kT, 


class ising():

    def startmagnet(steps=50, Hext=0, kTmax=6, kTmin=1/50., J=1):
        kT = np.linspace(kTmin, kTmax, nsteps, dtype=float)
        return kT, Hext, J
       
    def metropolis(magnet, kT, inds):
        N, M = magnet.shape[0], magnet.shape[1]
        DE = -magnet[inds[0], inds[1]]*(
                + magnet[inds[0]-1, inds[1]]
                + magnet[inds[0]-(N-1), inds[1]]
                + magnet[inds[0], inds[1]-1]
                + magnet[inds[0], inds[1]-(M-1)]
                )
        if DE < 0 or DE/kT < rd.rand():
            magnet[inds[0], inds[1]] = -magnet[inds[0], inds[1]]
        return magnet, DE


mag = magnet()
kT, Hext, J = ising.startmagnet()
