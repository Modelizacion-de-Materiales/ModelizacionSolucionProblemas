def miexp(x,n):
    serie = 0
    for i in range (n+1):
        serie = serie + (x**i)/factorial(i)
    return serie


def error(xo, intn):
    return abs(miexp(xo, intn) - np.exp(0.5))/abs(np.exp(0.5))


then = 1
ERR = []
ERR.append(np.array(error(0.5, then)))
while ERR[-1] >= 1e-4:
    then = then+1
    ERR.append(error(0.5, then))
