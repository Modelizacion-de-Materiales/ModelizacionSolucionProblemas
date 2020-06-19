#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import matplotlib.pyplot as plt
from barrat import barra
from ejercicio2_guia1 import plotlistT, plotFs
import pdb

B = barra(L=0.1)
B.mesh(4)

dt = 0.1
T, F = B.evolve(tmax=1e4, tol=1e-2)

case = 'dt_{:.2f}.dat'.format(dt)
np.savetxt('Temps'+case, T)
np.savetxt('Flujos'+case, F)
plotlistT('Temps'+case, dt)
plotFs('Flujos'+case, dt)
