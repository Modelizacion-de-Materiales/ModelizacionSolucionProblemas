import numpy as np
import sys
sys.path.append("../")
import mefmods as mef
import pdb

GL, MC, MN = mef.getgeo('Puente.ge')
S = np.array([1, 2, 5])
R = np.array([3, 4, 6, 7, 8])
# falta armar las matrices elementales
K = mef.ensamble(MC, MN, 200e9*np.ones((len(MC), 1)), GL, 2)
