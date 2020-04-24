#!/usr/bin/python3
# np necesito para algebra lineal y matematica
import numpy as np
# para calcular los factoriales
from math import factorial
# plot de matplotlin.pyplot
from matplotlib import pyplot as plt
# para medir el tiempo de ejecución
import time
# para embellecerel gráfico
from matplotlib import rc
# pdb es un modulo para debug
import pdb
rc('font', **{'family': 'sans-serif', 'sans-serif': ['Helvetica']})
rc('text', usetex=True)


def miexp(x, n):
    serie = 0

    to = time.time()

    for i in range(n+1):
        # si quiciera parar aca y 'debuguear', lo hago con este comando.
        # pdb.set_trace()
        serie = serie + (x**i)/factorial(i)

    dt = time.time() - to

    return serie, dt


def error(xo, intn):

    return abs(miexp(xo, intn) - np.exp(0.5))/abs(np.exp(0.5))


then = 1
ERR = []
times = []
e , t = error(0.5, then)
ERR.append(e)
times.append(t)

# pdb.set_trace()
while ERR[-1] >= 1e-4:
    then = then+1
    e, t = error(0.5, then)
    times.append(t)
    ERR.append(e)

print(len(ERR))

fig, ax1 = plt.subplots(figsize=(6, 4))
ax1.set_position([0.15, 0.15, 0.8, 0.7])
# axes = fig.add_axes([0.2, 0.2, 0.7, 0.6])
ax1.semilogy(ERR, '-o')
ax1.set_xlabel(r' n ')
ax1.tick_params(axis='x', labelsize=14)
ax1.tick_params(axis='y', labelsize=14)
ax1.grid(True)
ax1.set_ylabel(r' $$  ERR(x,n) = \Bigl \vert \frac{ f(x) - S_n (x)}{f(x)} \Bigr \vert $$ ')
plt.title(r'$$ S_n (x) = \sum_{i=1} ^n \frac{ x^i }{i !} $$  ', y=1.0)

# x = np.linspace(-1,1,1000)
# y = miexp(x,3)
# plt.plot(x, y,'o')
# plt.plot(x, np.exp(x))
# plt.show()
plt.savefig('Figura2.pdf',format='pdf')


