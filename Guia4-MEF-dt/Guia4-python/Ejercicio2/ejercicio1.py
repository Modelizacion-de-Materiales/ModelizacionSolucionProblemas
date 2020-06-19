import numpy as np
import matplotlib.pyplot as plt
from barrat import barra
from ejercicio2_guia1 import plotlistT
import pdb

B = barra()
B.mesh(4)

dt = 0.1
T, F = B.evolve(tmax=1e4, tol=1e-2)

np.savetxt('Temperature.dat', T)
plotlistT('Temperature.dat', dt)
