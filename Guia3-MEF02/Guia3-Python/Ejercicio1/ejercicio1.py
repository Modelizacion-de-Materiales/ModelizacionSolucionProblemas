#!/usr/bin/python3
# -*- coding: utf8 -*-
from meshmods import mesh
import mefmods as mef
import pdb
import numpy as np
thiscase='chapa-sym'
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
UR, FS = mef.resolvermef(R, S, K, US, FR, thiscase)
pdb.set_trace()
pass
# print(CHAPA.elements)
# print(CHAPA.MN)
# print(CHAPA.physcodes)
# print(CHAPA.physnames)
