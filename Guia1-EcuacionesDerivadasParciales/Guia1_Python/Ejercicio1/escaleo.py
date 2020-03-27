import numpy as np
import matplotlib.pyplot as plt
import time
from ejercicio1 import makensolve
import tycc, geo, valcc

Nx = 3**np.linspace(2, 4, 10)
Nx = Nx.astype(int)

for size in Nx:
    geo.Nx = size
    geo.Ny = size
    T, dt = makensolve(geo, tycc, valcc)
    print(size,dt)

