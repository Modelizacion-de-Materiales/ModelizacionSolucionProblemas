#!/usr/bin/env python3
# -*- coding: utf8 -*-
import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import eigh
from viga import Viga
import plotfrecs as pf
import pdb

# primero trato de hacer una matriz de nodos cualquiera
V = Viga(1, 210e9, 10e-4, 7850, 10e-8)
# V.mesh(3, 'trans')

# Estudio de convergencia, modos transversales lump vs consistentes
maxmode = 4
nmax = 15
wtrans, dtrans = V.converge_study(nmax, maxmode, 'trans')
# solucion de muchos modos
V.mesh(100, 'trans')
wv, dv = V.solvemods(V.K, V.M)
dv = dv[::2, :] / dv[-2, :]
xv = np.linspace(0, 1, 101)
wtrans_lump, dtrans_lump = V.converge_study(nmax, maxmode,  'trans_lump')

MODES = [dtrans, dtrans_lump]
# MODES[caso][nnodos][nodo, modo]
labels = ('consistentes', 'concentradas')
pf.plotmodes(MODES, [2, 6, 10], dv, labels, 'transversales')

ws = [wtrans, wtrans_lump]
cases = ['consistente', 'concentrada']
name='transversal'
pf.plotfrecs(ws, cases, name)
# cases = np.linspace(2, len(MODES[0]), 3, dtype=int)
# maxmode = MODES[0][-1][-1].shape[1]
# ncases = len(cases)
# for M in range(maxmode):
#     # M para los modos 
#     figM, axM = plt.subplots(len(labels), 1, sharex=True)
#     for l in range(len(labels)):
#         # l para el label -> MODE[l][][M]
#         pl = []
#         caselabel = []
#         for i, case in enumerate(cases):
# #            if case < M:
#             x = np.linspace(0, 1, case+1)
#             pl.append(axM[l].plot(x, MODES[l][case-1][0][:, M], 'o:')[0])
#             caselabel.append('{} nodos'.format(case))
#         pl.append(axM[l].plot(xv, dv[:, M]))
#         caselabel.append('100 nodos')
#         axM[l].legend(labels=[], title=labels[l], loc='upper left')
#     figM.legend(handles=pl, labels=caselabel, ncol=3, loc='upper center')
#     plt.savefig('Modo_{}.pdf'.format(M))
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
