import numpy as np
import matplotlib.pyplot as plt
from barrat import barra
import pdb

B = barra()
B.mesh(4)

dt = 0.1
T, F = B.evolve(tmax=10e3, tol=1e-2)
