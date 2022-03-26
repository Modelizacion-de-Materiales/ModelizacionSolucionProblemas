import numpy as np
import math

def miexp(x,n):
    serie = 0
    for i in range (n+1):
        serie = serie + (x**i)/math.factorial(i)
    return serie


def error(xo, intn):
    return abs(miexp(xo, intn) - np.exp(0.5))/abs(np.exp(0.5))


n = 1
ERR = np.array([ error(0.5, n) ])
while ERR[-1] >= 1e-4:
    n += 1
    np.append(ERR,error(0.5, n))
