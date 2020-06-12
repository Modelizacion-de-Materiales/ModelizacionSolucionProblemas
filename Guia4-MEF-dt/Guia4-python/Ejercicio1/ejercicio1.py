#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import eigh
from viga import Viga
import plotfrecs as pf
import pdb

# primero trato de hacer una matriz de nodos cualquiera
V = Viga(1, 210e9, 10e-4, 7850, 10e-8)
# V.mesh(3, 'trans')

# Estudio de convergencia, modos transversales lump vs consistentes
maxmode = 6
nmax = 15
wtrans, dtrans = V.converge_study(nmax, maxmode, 'trans')
# solucion de muchos modos
V.mesh(100, 'trans')
wv, dv = V.solvemods(V.K, V.M)
# dv = dv[::2, :] / dv[-2, :]
xv = np.linspace(0, 1, 101)
wtrans_lump, dtrans_lump = V.converge_study(nmax, maxmode,  'trans_lump')

MODES = [dtrans, dtrans_lump]
labels=('consistentes', 'concentradadas')
pf.plotmodes(MODES, [2, 6, 10], dv, labels, 'transversales')

ws = [wtrans, wtrans_lump]
cases = ['consistente', 'concentrada']
name='transversal'
pf.plotfrecs(ws, cases, name)

# los primeros 5 modos trans
pf.allmodesplot(dv[:,:5], 'transversales', fig_size=(4, 10))
