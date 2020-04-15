import numpy as np
import sys
sys.path.append("../")
import mefmods as mef


def init():
    mir = np.array([2, 3], dtype=int)
    mis = np.array([1, 4], dtype=int)
    mius = np.array([0, 0.002], dtype=float).reshape([2, 1])
    miMC = np.array([[1 , 2], [2, 3], [3, 4]])
    miMN = np.array([ 1, 2, 3, 4], dtype=float).reshape(4, 1)
    return mir, mis, mius, miMC, miMN, 1


if __name__ == '__main__':
    r, s, us, MC, MN, gl = init()
    K = mef.ensamble(MC, MN, gl, 1)
    pdb.set_trace()
    K = 200*np.array([[1, -1, 0, 0], [-1, 2, -1, 0], [0, -1, 2, -1], [0, 0, -1, 1]], dtype=float)
    fr = np.zeros([2, 1], dtype=float)

    # U, F = mef.resolvermef(r-1, s-1, K, us, fr, 'resortes')
