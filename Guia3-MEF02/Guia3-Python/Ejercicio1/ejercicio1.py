#!/usr/bin/python3
# -*- coding: utf8 -*-
from meshmods import mesh
import mefmods as mef
import pdb
import numpy as np
thiscase = 'chapa-nosym'
CHAPA = mesh(thiscase+'.msh')
CHAPA.newreadmsh()
CHAPA.GL = 2
MC = CHAPA.elements[CHAPA.physnames.index('"sheet"')]-1
LEMB = CHAPA.elements[CHAPA.physnames.index('"embedded"')]
LSTRE = CHAPA.elements[CHAPA.physnames.index('"stress"')]
R, S, US, FR = mef.mkbound(CHAPA, [LEMB, LSTRE], '"embedded"', [0, 1000] )
ETYPES = 2*np.ones(len(MC))
nu = 0.3  # Modulo de Poison
E = 30E6  # GPa
MP = np.hstack(
        (
            np.ones((len(MC), 1)),
            np.ones((len(MC), 1))*nu,
            np.ones((len(MC), 1))*E
            )
        )
K = mef.ensamble(MC, CHAPA.MN, MP, CHAPA.GL, ETYPES, thiscase)
pdb.set_trace()
U, F = mef.resolvermef(R, S, K, US, FR, thiscase)
CHAPA.writemsh(thiscase+'-out.msh')
Uxyz = np.zeros(CHAPA.MN.shape)
Fxyz = np.zeros(CHAPA.MN.shape)
for n in range(len(CHAPA.MN)):
   Uxyz[n] = [U[n*CHAPA.GL], U[n*CHAPA.GL+1], 0]
   Fxyz[n] = [F[n*CHAPA.GL], F[n*CHAPA.GL+1], 0]
Uxyz = np.array(Uxyz)
Fxyz = np.array(Fxyz)
CHAPA.writedatablock(thiscase+'-out.msh', Uxyz, '"Desplazamientos"', 0, 0.)
CHAPA.writedatablock(thiscase+'-out.msh', Fxyz, '"Fuerzas"', 0, 0.)
sigma = mef.getstress(CHAPA, MP, U)
CHAPA.writedatablock(thiscase+'-out.msh', sigma[:, 0], '"sigma_x"', 0, 0., dim=1, blocktype='ElementData')
CHAPA.writedatablock(thiscase+'-out.msh', sigma[:, 1], '"sigma_y"', 0, 0., dim=1, blocktype='ElementData')
CHAPA.writedatablock(thiscase+'-out.msh', sigma[:, 2], '"tau_xy"', 0, 0., dim=1, blocktype='ElementData')
SA = 0.5*(sigma[:, 0] + sigma[:, 1])
SB = np.sqrt(SA**2 + sigma[:, 2]**2)
sigma_max = SA + SB
sigma_min = SA - SB
CHAPA.writedatablock(thiscase+'-out.msh', sigma_max, '"sigma_max"', 0, 0., dim=1, blocktype='ElementData')
CHAPA.writedatablock(thiscase+'-out.msh', sigma_min, '"sigma_min"', 0, 0., dim=1, blocktype='ElementData')

# print(CHAPA.elements)
# print(CHAPA.MN)
# print(CHAPA.physcodes)
# print(CHAPA.physnames)
