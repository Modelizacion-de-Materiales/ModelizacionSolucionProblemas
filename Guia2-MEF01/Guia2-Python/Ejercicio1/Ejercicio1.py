import numpy as np
import sys
sys.path.append("../")
import mefmods as mef
import pdb


class springs:
    def __init__(self, k=200e3):
        self.gl = 1    # un grado de libertad por nodo
        self.r = np.array([2, 3], dtype=int)  # vectores incognits
        self.s = np.array([1, 4], dtype=int)  # vinculos
        self.us = np.array([0, 0.002], dtype=float).reshape([2, 1])  # vinculos
        self.MC = np.array([[1, 2], [2, 3], [3, 4]])  # conectividad
        self.MN = np.array([1, 2, 3, 4], dtype=float).reshape(4, 1)  # Nodos
        self.K = mef.ensamble(self.MC, self.MN, self.gl, 1)  # Mat rigidez
#        self.K = 200*np.array(
#                [[1, -1, 0, 0], [-1, 2, -1, 0], [0, -1, 2, -1], [0, 0, -1, 1]],
#                dtype=float)  # 
        self.fr = np.zeros([2, 1], dtype=float)   # resuevlo fuerzas de vinculo
        #pdb.set_trace()
        self.U, self.F = mef.resolvermef(
                self.r-1, self.s-1, self.K, self.us, self.fr, 'resortes'
                ) # Resuelvo Desplazamientos


resortes = springs()
