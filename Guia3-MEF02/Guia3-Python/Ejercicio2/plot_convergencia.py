import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

F = pd.read_csv('convergencia-entera.txt', sep=r'\s+')

Fwpoints = F[F['msh']=='chapa-entera-fino-points']
Fcuarto  = F[F['msh']=='chapa']
Fwlines  = F[F['msh']=='chapa-entera-fino']

plt.plot(Fwpoints['escala'], Fwpoints['sigma_max'],':o', label="por puntos")
plt.plot(Fcuarto['escala'], Fcuarto['sigma_max'],  ':o', label="curarto de chapa")
plt.plot(Fwlines['escala'], Fwlines['sigma_max'],  ':o', label="por lineas")
plt.xlabel('factor de escala')
plt.ylabel(r'$\sigma_{max}$')
plt.legend()
plt.savefig('convergencias.pdf')
