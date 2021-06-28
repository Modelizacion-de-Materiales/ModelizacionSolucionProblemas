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

    def __init__(self, N=2, J=-1):
        self.s = rd.randint(2, size=(N, N))*2-1
        s = self.s
        self.J = J
        self.M = np.sum(np.sum(s))
        self.Eo = self.Energy()
        #(J/2)*(
        #        s*(np.roll(s, 1, 0) + np.roll(s, -1, 0) + np.roll(s, 1, 1) + np.roll(s, -1, 1))
        #        ).sum()
        

    def Energy(self):
        return (self.J/2)*(
                self.s*(
                      np.roll(self.s, 1, 0) 
                    + np.roll(self.s, -1, 0) 
                    + np.roll(self.s, 1, 1) 
                    + np.roll(self.s, -1, 1)
                    )
                ).sum()

    def termalize(self, kT=5, TermaIter=10000, makeacums=True):
        flip_index = rd.randint(self.s.shape[0], size=(TermaIter, 2))
        s = self.s
        E = self.Energy()
        M = s.sum().sum()
        if makeacums:
            acumM = s.sum().sum()
            acumE = self.Energy()
        for i in range(TermaIter):
            s, dE, dM = ising.metropolis(s, kT,  flip_index[i])
            if makeacums:
                E += dE
                M += dM
                acumE += E
                acumM += abs(M)
            self.s = s
        self.s = s
        if makeacums:
            return s, E, M, acumE/TermaIter, acumM/TermaIter
        else:
            return s, E, M

    def cool_down(self, kTs, MCSTEPS):
        ACUMS = []
        for i, kT in enumerate(kTs):
            s, E, M, E_ACUM, M_ACUM = self.termalize(kT=kT, TermaIter=MCSTEPS)
            ACUMS.append([E_ACUM, M_ACUM])
        return np.array(ACUMS)

class ising():

    def startmagnet(steps=50, Hext=0, kTmax=6, kTmin=1/50., J=1,):
        kT = np.linspace(kTmin, kTmax, steps, dtype=float)
        return kT, Hext, J

    def metropolis(magnet, kT, inds):
        N, M = magnet.shape[0], magnet.shape[1]
        DE = -magnet[inds[0], inds[1]]*(
                + magnet[inds[0]-1, inds[1]]
                + magnet[inds[0]-(N-1), inds[1]]
                + magnet[inds[0], inds[1]-1]
                + magnet[inds[0], inds[1]-(M-1)]
                )
        DM = 0
        if DE < 0 or DE/kT < rd.rand():
            magnet[inds[0], inds[1]] = -magnet[inds[0], inds[1]]
            DM = -2*magnet[inds[0], inds[1]]
        return magnet, DE, DM


if __name__ == "__main__":
    mag = magnet()
    kT, Hext, J = ising.startmagnet()
    ACUMS = mag.cool_down(kT, 10000)
