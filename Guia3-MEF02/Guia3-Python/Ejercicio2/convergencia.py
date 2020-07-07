from meshmods import mesh
import mefmods as mef
import pdb
import numpy as np
import sys, os


fes = [0.025, 0.0, 0.1, 0.2, 0.5, 1, 2 ]

comandbase = 'sed \'s#.*cl1 = .*#cl1 = {0};#\' chapa.geo > chapa{0}.geo'

for f in fes:
    thiscase = 'chapa'+'{}'.format(f)
#    print(thiscase)
    os.system(comandbase.format(f))
    os.system('head -1 chapa{}.geo'.format(f))
    os.system('gmsh -format msh22 {0}.geo -2 -o {0}.msh &> /dev/null'.format(thiscase))
    os.system('python3 ejercicio2.py {}'.format(thiscase))
