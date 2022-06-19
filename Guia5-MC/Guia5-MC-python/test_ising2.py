import unittest
import ising2 as mod
import numpy as np


class TestMagnet(unittest.TestCase):

    @classmethod
    def setUp(cls):
        pass

    def test_has_spins(self):
        magnet = mod.Magnet()
        self.assertTrue(hasattr(magnet, 's'))

    def test_shape_indicators(self):
        magnet = mod.Magnet()
        self.assertEqual(magnet.Nx, 2)
        self.assertEqual(magnet.Ny, 2)
        self.assertEqual(magnet.N, 4)

    def test_magnetized(self):
        for thiss in [-1*np.ones([2,2]), np.ones( [2,2]), np.ones([8,8])]:
            magnet = mod.Magnet(s=thiss)
            moment = magnet.get_magnetic_moment()
            self.assertEqual(abs(moment), magnet.N)

    def test_magnetic_energy(self):
        for thiss in [-1*np.ones([2,2]), np.ones( [2,2]), np.ones([8,8])]:
            magnet = mod.Magnet(s=thiss)
            energy = magnet.get_total_energy()
            self.assertEqual(-2*magnet.J*magnet.N, energy)

    def test_flip_a_spin(self):
        magnet = mod.Magnet(Nx=16, Ny=16)
        spin44 = magnet.s[4,4]
        magnet.flipthespin(4,4)
        self.assertEqual(spin44, -1*magnet.s[4,4])

    def test_mchange_onflip(self):
        magnet = mod.Magnet(np.ones([ 2,2 ]))
        dm = magnet.get_mchange_onflip(0,0)
        self.assertEqual(dm, -2.)
        magnet = mod.Magnet(-np.ones([ 2,2 ]))
        dm = magnet.get_mchange_onflip(0,0)
        self.assertEqual(dm, 2.)
#
    def test_energy_after_flip(self):
        magnet = mod.Magnet(s=np.ones([2,2]))
        magnet.flipthespin(0,0)
        enew = magnet.get_total_energy()
        self.assertEqual(enew, 0)
#
#
    def test_echange_onflip(self):
        for thiss in [np.ones([2,2]), -1*np.ones( [2,2]), np.ones([8,8])]:
            magnet = mod.Magnet(s=thiss)
            E = magnet.get_total_energy()
            detest = magnet.get_total_echange_onflip(0,0)
            magnet.flipthespin(0,0)
            enew = magnet.get_total_energy()
            self.assertEqual(detest, enew - E)

    def test_echange_isnegative(self):
        magnet = mod.Magnet(s = np.array([[-1,1], [1,1]]))
        detest = magnet.get_total_echange_onflip(0,0)
        self.assertTrue(detest < 0)

    def test_exact_echange(self):
        magnet = mod.Magnet(s = np.ones([2,2]) )
        detest = magnet.get_total_echange_onflip(0,0)
        self.assertEqual(detest , 8*magnet.J)

#
    def test_randoms(self):
        randoms, flipi, flipj = mod.get_randoms(2,2, 1000)
        self.assertEqual(len(randoms),  1000)
        self.assertEqual(len(flipi),  1000)
        self.assertEqual(len(flipj),  1000)
        self.assertTrue(flipi.max() <= 1)
        self.assertTrue(flipi.min() >= 0)
        self.assertTrue(flipj.max() <= 1)
        self.assertTrue(flipj.min() >= 0)
#
    def test_e_at_inf(self):
        """
        test if after termalization, the energy is as expected at low temperature (i e close to minimal)
        """
        np.random.seed(42)
        thiss = np.random.randint(2, size=[4,4])*2-1
        magnet = mod.Magnet(s=thiss)
        ef = 0.
        nsteps = 1e4
        magnet, results = mod.termalize(magnet, nsteps = int(nsteps), T = 8)
        self.assertAlmostEqual(ef/magnet.N, results['EMEAN']/magnet.N, delta=0.25)

    def test_M_at_inf(self):
        np.random.seed(42)
        thiss = np.random.randint(2, size=[4,4])*2 -1
        magnet = mod.Magnet(s = thiss)
        mf = 0
        nsteps = 1e4
        magnet, results = mod.termalize(magnet, nsteps = int(nsteps), T = 10)
        self.assertAlmostEqual(mf/magnet.N, results['MabsMEAN']/magnet.N, delta = 0.26)

    def test_M_at_0(self):
        np.random.seed(42)
        thiss = np.random.randint(2, size=[4,4])*2-1
        magnet = mod.Magnet(s=thiss)
        mf = 1.
        magnet, results = mod.termalize(magnet, nsteps = int(1e4), T = 0.1)
        self.assertAlmostEqual(mf, results['MabsMEAN']/magnet.N, delta = 2e-3)


if __name__ == '__main__':
    unittest.main()
