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


x = np.linspace(-1,1,1000)
y = miexp(x,5)
plt.plot(x,y)
plt.show()
plt.savefig('figura.png')
