import numpy as np
import sys
sys.path.append("../")
import mefmods as mef
import pdb

class springs:
    def __init__(self, k=200e3):
        self.gl = 1    # un grado de libertad por nodo
        self.r = np.array([1, 2], dtype=int)  # vectores incognits
        self.s = np.array([0, 3], dtype=int)  # vinculos
        self.us = np.array([0, 0.002], dtype=float).reshape([2, 1])  # vinculos
        self.MC = np.array([[0, 1], [1, 2], [2, 3]])  # conectividad
        self.MN = np.array([0, 1, 2, 3], dtype=float).reshape(4, 1)  # Nodos
        self.MP = 200 * np.ones((len(self.MN), 1))
        # |self.K = mef.ensamble(self.MC, self.MN, self.GL, etype=1, case='resortes')  # Mat rigidez
        self.K = mef.ensamble(self.MC, self.MN, self.MP, self.gl, 1, case='resortes')  # Mat rigidez
#        self.K = 200*np.array(
#                [[1, -1, 0, 0], [-1, 2, -1, 0], [0, -1, 2, -1], [0, 0, -1, 1]],
#                dtype=float)  # 
        self.fr = np.zeros([2, 1], dtype=float)   # resuevlo fuerzas de vinculo
        #pdb.set_trace()
        self.U, self.F = mef.resolvermef(
                self.r, self.s, self.K, self.us, self.fr, 'resortes'
                ) # Resuelvo Desplazamientos


resortes = springs()
