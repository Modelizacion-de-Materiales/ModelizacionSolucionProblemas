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
maxmode = 4
nmax = 25
wlong, dlong = V.converge_study(nmax, maxmode, 'long')
# solucion de muchos modos
V.mesh(100, 'long')
wvL, dvL = V.solvemods(V.K, V.M)
# dv = dv[::2, :] / dv[-2, :]
xv = np.linspace(0, 1, 101)
wlong_lump, dlong_lump = V.converge_study(nmax, maxmode,  'long_lump')

MODESL = [dlong, dlong_lump]
labels = ('consistentes', 'concentradadas')
# pf.plotmodes(MODESL, [2, 6, 10], dvL, labels, 'transversales')a
# para hacer los graficos de las convergencias de los modos tengo que hacer una fun nueva
# porque tengo que cambiar las funciones de interpolacion!

wsL = [wlong, wlong_lump]
cases = ['consistente', 'concentrada']
name = 'longitudinal'
pf.plotfrecs(wsL, cases, name)

pf.allmodesplot(dvL[:, :5], 'longitudinales', fig_size=(4, 10))

