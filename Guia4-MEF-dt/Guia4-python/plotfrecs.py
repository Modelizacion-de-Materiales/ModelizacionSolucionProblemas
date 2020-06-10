import matplotlib.pyplot as plt
import numpy as np
import pdb
plt.rc('text',usetex=True)


def plotfrecs(ws, cases, name):
    maxmode = ws[1].shape[1]
    fig, ax = plt.subplots(maxmode, 1,  figsize=(5, 8), sharex=True)
    for M in range(maxmode):
        axnum = maxmode-M-1
        lin = []
        for i in range(len(cases)):
            lin.append(ax[axnum].plot(ws[i][:, M], 'o-', label=cases[i])[0])
            ax[axnum].legend(labels=[], title='modo {:d}'.format(M+1), loc='upper right')
    ax[-1].set_xlabel('Numero de nodos')
    ax[int(maxmode/M)].set_ylabel('frecuencia(Hz)')
    fig.legend(lin,
            labels=cases,
            loc='upper center',
            ncol=2,
            )
    plt.savefig('frecuencias'+name+'.pdf')
    plt.close()


def plotmodes(MODES, cases, dv, labels, name):
    # cases = np.linspace(2, len(MODES[0]), 3, dtype=int)
    # ncases = len(cases)
    maxmode = MODES[0][-1][-1].shape[1]
    xv = np.linspace(0, 1, dv.shape[0])
    for M in range(maxmode):
        # M para los modos 
        figM, axM = plt.subplots(len(labels), 1, sharex=True)
        for l in range(len(labels)):
            # l para el label -> MODE[l][][M]
            pl = []
            caselabel = []
            for i, case in enumerate(cases):
#                if case < M:
                    x = np.linspace(0, 1, case+1)
                    pl.append(axM[l].plot(x, MODES[l][case-1][0][:, M], 'o:')[0])
                    caselabel.append('{} nodos'.format(case))
            pl.append(axM[l].plot(xv, dv[:, M])[0])
            caselabel.append('{} nodos'.format(xv.shape[0]))
            axM[l].legend(labels=[], title=labels[l], loc='upper left')
        pdb.set_trace()
        figM.legend(handles=pl, labels=caselabel, ncol=len(caselabel), loc='upper center')
        plt.savefig(name+'Modo_{}.pdf'.format(M))
        plt.close()


