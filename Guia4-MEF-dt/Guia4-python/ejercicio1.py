#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import mefmods as mef
from scipy.linalg import eigh
import matplotlib.pyplot as plt
from viga import Viga
import pdb
plot.rc('text', usetex=True)

# primero trato de hacer una matriz de nodos cualquiera
V = Viga(1, 210e9, 10e-4, 7850, 10e-8)
# V.mesh(3, 'trans')

# Estudio de convergencia, modos transversales lump vs consistentes
maxmode = 4
nmax = 15
wtrans, dtrans = V.converge_study(nmax, maxmode, 'trans')
wtrans_lump, dtrans_lump = V.converge_study(nmax, maxmode,  'trans_lump')

# fig, ax = plt.subplots( maxmode, 1,  figsize=(8, 20), sharex=True)
# for M in range(maxmode):
#     axnum = maxmode-M-1
#     l1 = ax[axnum].plot(wtrans[:, M], 'o-b', label='masas consistentes')[0]
#     l2 = ax[axnum].plot(wtrans_lump[:, M], 'o-r', label='masas consistentes')[0]
#     ax[axnum].legend(labels=[], title='modo {:d}'.format(M+1), loc='upper right')
# ax[-1].set_xlabel('Numero de nodos')
# ax[int(maxmode/M)].set_ylabel('frecuencia(Hz)')
# fig.legend([l1, l2],
#         labels=( 'masas concentradas', 'masas consistentes'), 
#         loc='upper center',
#         ncol=2
#         ),
# #        loc='upper center', bbox_to_anchor=(0.2, 1.5), mode='expand')
# plt.savefig('frecuencias-transvers.pdf')
# plt.close()
# ahora tengo que ver la evolucion de los modos 
