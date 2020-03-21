#!/usr/bin/python3
import numpy as np
from math import factorial 
# 
from matplotlib import pyplot as plt
from matplotlib import rc
#import pdb
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text',usetex=True)

def miexp(x,n):
    serie = 0
    for i in range (n+1):
        #pdb.set_trace()
        serie = serie + (x**i)/factorial(i)

    return serie


def error(x, intn):

    return abs(miexp(x, intn) - np.exp(0.5))/abs(np.exp(0.5))

then=1
ERR = []; ERR.append(np.array(error(0.5, then)))
while ERR[-1] >= 1e-4:
    then = then+1
    ERR.append(error(0.5, then))

print(len(ERR))

fig=plt.figure(figsize=(6, 4))
axes=fig.add_axes([0.2, 0.2, 0.7, 0.6])
axes.semilogy(ERR,'-o')
plt.xlabel(r' n ')
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.ylabel(r' $$  ERR(x,n) = \Bigl \vert \frac{ f(x) - S_n (x)}{f(x)} \Bigr \vert $$ ' )
plt.title(r'$$ S_n (x) = \sum_{i=1} ^n \frac{ x^i }{i !} $$  ', y=1.0)

#x = np.linspace(-1,1,1000)
#y = miexp(x,3)
#plt.plot(x, y,'o')
#plt.plot(x, np.exp(x))
#plt.show()
plt.savefig('figura.pdf',format='pdf') 


