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
K = mef.ensamble(MC, MN, MP, GL, 2)
K[abs(K) < 1e-9] = 0
np.savetxt('Kglobal', K, fmt='%.4e')
pdb.set_trace()
U, F = mef.resolvermef(R, S, K, US, FR, 'puente')
np.savetxt('Desplazamientos.dat', U)
np.savetxt('Fuerzas.dat', F)
