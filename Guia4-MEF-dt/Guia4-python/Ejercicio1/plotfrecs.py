import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
import pdb
from mefmods import NT1, NT2, NT3, NT4

plt.rc('text',usetex=True)
plt.rc('font', size=14)


def plotfrecs(ws, cases, name, glstep=2, fig_size=(5, 8)):
    maxmode = ws[1].shape[1]
    fig, ax = plt.subplots(maxmode, 1,  figsize=(5, 8), sharex=True)
    fig.subplots_adjust(
            hspace=0.05,
            top=0.9,
            left=0.2,
            right=0.97
            )
    ax[-1].set_xlabel('Numero de nodos')
    ax[-1].annotate('frecuencia(Hz)',
            (0.02, 0.5), xycoords='figure fraction',
            xytext=(0, 0), textcoords='offset points',
            rotation=90
            )
    nelem = np.linspace(0, len(ws[0])-1, len(ws[0]), dtype=int)+1
    nodes = nelem+1
    for M in range(maxmode):
        axnum = maxmode-M-1
        lin = []
        for i in range(len(cases)):
            lin.append(ax[axnum].plot(nodes, ws[i][:, M], 'o-', label=cases[i])[0])
            ax[axnum].legend(labels=[], title='modo {:d}'.format(M+1), loc='upper right')
    fig.legend(lin,
            labels=cases,
            loc='upper center',
            ncol=2
            )
    fig.tight_layout()
    plt.savefig('frecuencias'+name+'.pdf')
    # plt.close()

    
# me falta una función para graficar todos los modos juntos
def allmodesplot(dv, name, fig_size=(5, 7), font_size=14, glstep=2):
    ds = dv[::glstep, :]/dv[-glstep, :]
    x = np.linspace(0, 1, ds.shape[0])
    fig, ax = plt.subplots(1, 1)
    fig. subplots_adjust(right=0.9, top=0.85, left = 0.15)
    for M in range(ds.shape[1]):
        ax.plot(x, ds[:, M], label='{}'.format(M+1))
    ax.legend(title='Modos '+name+' para {} nodos'.format(ds.shape[0]), 
            loc='center',
            bbox_to_anchor=(0.5, 1.1),
            ncol=ds.shape[1])
    ax.set_xlabel('X')
    ax.set_ylabel(r'$\Delta y$')
    fig.savefig(name+'allmodes.pdf')
    return fig, ax
    #plt.close()


