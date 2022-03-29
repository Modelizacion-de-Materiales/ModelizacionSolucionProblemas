import numpy as np
from math import factorial # para calcular los factoriales

def miexp(x, n):
    return sum([(x**i)/factorial(i) for i in range(n+1)])

def error(xo, intn):
    return abs(miexp(xo, intn) - np.exp(0.5))/abs(np.exp(0.5))

then = 1
ERR=[error(0.5, then)]

while ERR[-1] >= 1e-4:
    then = then+1
    ERR.append(error(0.5, then))

# grafico 
from matplotlib import pyplot as plt
from matplotlib import rc
plt.rc('figure', figsize=(15,8))
plt.rc('text', usetex=True)
plt.rc('font', size=28)
fig, ax1 = plt.subplots()
ax1.set_position([0.15, 0.15, 0.8, 0.7])
# axes = fig.add_axes([0.2, 0.2, 0.7, 0.6])
ax1.semilogy(ERR, '-o')
ax1.set_xlabel(r' n ')
ax1.grid(True)
ax1.set_ylabel(r' $$  ERR(x,n) = \Bigl \vert \frac{ f(x) - S_n (x)}{f(x)} \Bigr \vert $$ ')
fig.suptitle(r'$$ S_n (x) = \sum_{i=1} ^n \frac{ x^i }{i !} $$  ', y=1.0)
fig.tight_layout()
fig.savefig('Figura2.pdf',format='pdf')


