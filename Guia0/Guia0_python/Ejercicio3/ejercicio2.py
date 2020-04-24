from numpy import *
from matplotlib.pyplot import * 
from params import *


x=linspace(Xo,Xf,100)
plot ( x, yteo(x) , '-k', lw=5 )
show()



def rk4( _dt, _xo, _xf )
