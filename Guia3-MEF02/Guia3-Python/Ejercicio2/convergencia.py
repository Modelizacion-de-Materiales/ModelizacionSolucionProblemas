from meshmods import mesh
import mefmods as mef
import pdb
import numpy as np
import sys, os


fes = [0.025, 0.05, 0.1, 0.2, 0.5, 1 ]

#namebase = 'chapa-entera-fino-points'
#namebase = 'chapa-entera-fino'
names = ['chapa-entera-fino-points', 'chapa-entera-fino', 'chapa']

os.system('rm *.jpg')
for namebase in names:
    comandbase = 'sed \'s#.*cl1 = .*#cl1 = {0};#\' '+namebase+'.geo > '+namebase+'{0}.geo'
    for f in fes:
        thiscase = namebase+'{}'.format(f)
#        os.system(comandbase.format(f))
#        os.system('head -1 '+namebase+'{}.geo'.format(f))
#        os.system('gmsh -format msh22 {0}.geo -2 -o {0}.msh &> /dev/null'.format(thiscase))
#        os.system('python3 ejercicio2.py {}'.format(thiscase))
        os.system('sed -i \'s#model=.*#model=\"'+thiscase+'-out\";#\' chapa-post.geo')
        os.system('gmsh chapa-post.geo')

os.system('bash makereport.sh')
os.system('pdflatex report.tex')
