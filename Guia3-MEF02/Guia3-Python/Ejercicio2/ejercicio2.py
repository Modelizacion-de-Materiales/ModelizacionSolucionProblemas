#!/usr/bin/python3
# -*- coding: utf8 -*-
from meshmods import mesh
import mefmods as mef
import pdb
import numpy as np
import getopt, sys
#try: 
#    opts, args = getopt.getopt(sys.argv[1:], "hi:o:", ["ifile=", "ofile="])
#except getopt.GetoptError:
#    print('ejercicio2.py -i <inputfile> -o <outputfile>')
#    sys.exit()
if len(sys.argv) == 2:
    thiscase = sys.argv[-1]
else:
    thiscase = 'chapa'
CHAPA = mesh(thiscase+'.msh')
CHAPA.newreadmsh()
CHAPA.GL = 2
MC = CHAPA.elements[CHAPA.physnames.index('"sheet"')]-1
boundaries = []
boundary_conditions=[]
stresses = []
values = []
try:
    LEMB = CHAPA.elements[CHAPA.physnames.index('"embedd"')]
    boundaries.append(LEMB)
    boundary_conditions.append('"embedd"')
    values.append(0)
except:
    print('No hay empotramiento total')
try:
    LEMBX = CHAPA.elements[CHAPA.physnames.index('"embedd_x"')]
    boundaries.append(LEMBX)
    boundary_conditions.append('"embedd_x"')
    values.append(0)
except:
    print('No hay empotramiento parcial x')
try:
    LEMBY = CHAPA.elements[CHAPA.physnames.index('"embedd_y"')]
    boundaries.append(LEMBY)
    boundary_conditions.append('"embedd_y"')
    values.append(0)
except:
    print('No hay empotramiento parcial en y')
try:
    LSTRE = CHAPA.elements[CHAPA.physnames.index('"stress"')]
    boundaries.append(LSTRE)
    boundary_conditions.append('"stress"')
    values.append(1000)
except:
    print('No Hay stress')
try: 
    LSTRE1 = CHAPA.elements[CHAPA.physnames.index('"stress1"')]
    boundaries.append(LSTRE1)
    boundary_conditions.append('"stress1"')
    values.append(-1000)
except:
    print('no hay stress extra')
R, S, US, FR = mef.mkbound(
        CHAPA,
#        [LEMBX, LEMBY, LSTRE,  LSTRE1],
#        ('"embedd_x"', '"embedd_y"', '"stress"',   '"stress1"'),
        boundaries,
        boundary_conditions,
        values
#        [0, 0,  1000, -1000]
        )
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
CHAPA.writedatablock(
        thiscase+'-out.msh',
        np.hstack((Fxyz[:, 0].reshape(-1, 1), np.zeros((len(Fxyz), 2)))),
        '"F_x"',
        0,
        0.)
CHAPA.writedatablock(
        thiscase+'-out.msh', 
        np.hstack((np.zeros((len(Fxyz), 1)), Fxyz[:, 1:])),
        '"F_y"',
        0,
        0.)
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
print('case = {}, max(sigma_max) = {}'.format(thiscase, sigma_max.max()))

# print(CHAPA.elements)
# print(CHAPA.MN)
# print(CHAPA.physcodes)
# print(CHAPA.physnames)
