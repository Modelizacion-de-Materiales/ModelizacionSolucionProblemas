#!/usr/bin/env python
# coding: utf-8

import matplotlib.pyplot as plt
from tqdm.notebook import tqdm_notebook, tqdm
import numpy as np
from copy import copy
import pdb
import pickle

# system size
N = 10

# steps and dimensions
steps = int(1e5)
KT = np.hstack([ 2.2+np.logspace(-2, np.log10(2), 10) , 2.2-np.logspace(-2, np.log10(2),10)])
KT = KT[KT>0]
KT.sort()
KT = KT[::-1]
beta = 1/KT


# all the randoms
changes = np.random.randint(N, size=(steps, 2, len(beta)))
# coins = np.random.rand(steps, len(beta))

# acumulators and history
S = []
acumM = []
acumE = []
acumE2 = []
acumVAR = []
Mhist = []
Ehist = []
VARhist = []
flips = []
metroflips = []
boltsfactors = []

# fig, ax = plt.subplots(1,2)
#MDF-COMMENT progress = tqdm_notebook(enumerate(beta), ncols = 80, total=len(beta), ascii=True)
progress = tqdm(enumerate(beta), ncols = 80, total=len(beta), ascii=True)
for t, Beta in progress:

    if len(S) > 0:
        S.append(copy(S[-1]))
    else:
        S.append( np.random.randint(2, size=(N,N))*2-1)
        
    NEIG0 =np.roll(S, 1, 0)+np.roll(S[-1], -1, 0)+np.roll(S[-1], 1, 1)+np.roll(S[-1], -1, 1)
    E = [-0.5*(S[-1]*NEIG0).sum()]
    M = [S[-1].sum()]
    E2 = [E[-1]**2]
    DE = [0]
    Macum = np.abs(M); Eacum = sum(E) ; E2acum = sum(E2) ;
    VAR = sum(np.power(E,2)) - E2acum
    VARacum = sum(VAR)
    progress.set_description(f'Beta = {Beta}')
    flips.append(0)
    metroflips.append(0)
    boltsfactors.append([])
    for i, change in enumerate(changes[:,:,t]):
        NEIG = S[-1][change[0]-N,change[1]] + \
                S[-1][change[0]-1, change[1]] +\
                S[-1][change[0],change[1]-N] +\
                S[-1][change[0],change[1]-1] 
        Saux = -copy(S[-1][change[0],change[1]])
        DE_candidate = -2*Saux*NEIG
        boltsfactors[-1].append(np.exp(-Beta*DE_candidate))
        if (DE_candidate < 0): 
            S[-1][change[0],change[1]] = copy(Saux)# copy(Saux)
            DM = 2*copy(Saux)
            DE = copy(DE_candidate)
            flips[-1] += 1
        elif np.random.rand() < boltsfactors[-1][-1]: # coins[i, t] < boltsfactors[-1][-1]:
            S[-1][change[0],change[1]] = copy(Saux) #-1# copy(Saux)
            DE = copy(DE_candidate)
            DM = 2*copy(Saux)
            DE = copy(DE_candidate)
            metroflips[-1] += 1
        else: 
            DE = 0
        M.append(M[-1]+ DM)
        E.append((E[-1]+DE))
        E2.append(E[-1]**2)
#        VAR.append(E[-1]**2 - E2[-1])
        Macum += np.abs(M[-1])
        Eacum += E[-1]
        E2acum += E2[-1]
        VARacum += E2acum - sum(E)**2

    Mhist.append(M[::5])
    Ehist.append(E[::5])
    VARhist.append(VAR[::5])
    acumM.append(Macum)#/changes.shape[0]/N**2)
    acumE.append(Eacum)#/changes.shape[0]/N**2)
    acumE2.append(E2acum)#/changes.shape[0]/N**2)
    acumVAR.append(VARacum)
    
output_pickle = f'{N}x{N}_{changes.shape[0]}-steps.pkl'

with open(output_pickle, 'wb') as f:
    pickle.dump(np.array(KT), f)
    pickle.dump(np.array(changes), f)
    pickle.dump(np.array(S), f)
    pickle.dump(np.array(Mhist), f)
    pickle.dump(np.array(Ehist), f)
    pickle.dump(np.array(VARhist), f)
    pickle.dump(np.array(acumM), f)
    pickle.dump(np.array(acumE), f)
    pickle.dump(np.array(acumE2), f)
    pickle.dump(np.array(acumVAR), f)
