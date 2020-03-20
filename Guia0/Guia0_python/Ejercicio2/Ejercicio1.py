#!/usr/bin/python3
import numpy as np
from math import factorial 
# 
from matplotlib import pyplot as plt


import pdb


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

plt.semilogy(ERR)


#x = np.linspace(-1,1,1000)
#y = miexp(x,3)
#plt.plot(x, y,'o')
#plt.plot(x, np.exp(x))
#plt.show()
plt.savefig('figura.png') 


