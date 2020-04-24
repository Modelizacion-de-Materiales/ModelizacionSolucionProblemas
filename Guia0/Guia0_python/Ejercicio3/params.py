from numpy import exp

Xo = 0
Yo = 2
Xf = 4
dX = 0.1

def yteo(x):
    return ( 4 / 1.2 ) * ( exp( 0.8 * x ) - exp ( -0.5*x ) ) + 2* exp ( -0.5 * x )
