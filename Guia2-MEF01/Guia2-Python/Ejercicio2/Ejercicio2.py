import numpy as np
import sys
sys.path.append("../")
import mefmods as mef
import pdb

# GL: Grados de libertad por nodo,
# MC: matriz de conectividad
# MN: Matriz de nodos
# MP: Matriz de propiedades
# LVIN: Listas de Vínculos = (IVIN, MVIN): indices de vinculo (nodo, eje1, eje2), (Vin1, vind2))
#         si eje1 > 0 Vin1 es desplazamiento,
#         si eje1 < 0 vin1 es fuerza
GL, MC, MN, MP, LVIN = mef.getgeo('Puente.ge')
R, S, US, FR = mef.makevins(GL, len(MN), LVIN)
S = np.array([1, 2, 6])
R = np.array([3, 4, 5, 7, 8])
# falta armar las matrices elementales
K = mef.ensamble(MC, MN, MP, GL, 2)
np.savetxt('Kglobal', K, fmt='%.4e')
US = np.zeros((len(S), 1))
FR = np.zeros((len(R), 1))
FR[1] = -20e3
U, F = mef.resolvermef(R-1, S-1, K, US, FR, 'puente')

