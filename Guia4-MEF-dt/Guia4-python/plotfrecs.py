import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
import pdb
from mefmods import NT1, NT2, NT3, NT4

plt.rc('text',usetex=True)
plt.rc('font', size=14)


def plotfrecs(ws, cases, name):
    maxmode = ws[1].shape[1]
    fig, ax = plt.subplots(maxmode, 1,  figsize=(5, 8), sharex=True)
    fig.subplots_adjust(
            hspace=0.05,
            top=0.9, 
            left=0.15,
            right=0.97
            )
    [a.set_xticks([]) for a in ax[:-1]]
    nelem = np.linspace(0, len(ws[0])-1, len(ws[0]), dtype=int)+1
    nodes = nelem+1
    ax[-1].set_xticks(nodes)
    for M in range(maxmode):
        axnum = maxmode-M-1
        lin = []
        for i in range(len(cases)):
            lin.append(ax[axnum].plot(nodes, ws[i][:, M], 'o-', label=cases[i])[0])
            ax[axnum].legend(labels=[], title='modo {:d}'.format(M+1), loc='upper right')
    ax[-1].set_xlabel('Numero de nodos')
    ax[int(maxmode/M)].set_ylabel('frecuencia(Hz)')
    fig.legend(lin,
            labels=cases,
            loc='upper center',
            ncol=2,
            )
    plt.savefig('frecuencias'+name+'.pdf')
    # plt.close()


def plotmodes(MODES, cases, dv, labels, name):
    # cases = np.linspace(2, len(MODES[0]), 3, dtype=int)
    # ncases = len(cases)
    maxmode = MODES[0][-1][-1].shape[1]
    xv = np.linspace(0, 1, dv[::2].shape[0])
    for M in range(maxmode):
        # M para los modos 
        figM, axM = plt.subplots(len(labels), 1, sharex=True, figsize=(7,10))
        figM.subplots_adjust(
                hspace=0.05,
                top=0.9, 
                left=0.15,
                right=0.97
                )
        figM.suptitle('modo {}'.format(M))
        for l in range(len(labels)):
            # l para el label -> MODE[l][][M]
            pl = []
            pi = [] # lineas de interpolacion
            caselabel = []
            pl.append(axM[l].plot(xv, dv[::2, M]/dv[-2, M])[0])
            caselabel.append('{} nodos'.format(xv.shape[0]))
            for i, case in enumerate(cases):
                if  M < 2*case:
                    x = np.linspace(0, 1, case+1)
                    yn = MODES[l][case-1][0][::2, M]/MODES[l][case-1][0][-2,M]
                    thetan=MODES[l][case-1][0][1::2, M]/MODES[l][case-1][0][-2,M]
                    pl.append(axM[l].plot(x, yn , 'o')[0])
                    caselabel.append('{} nodos'.format(case))
                    y=[]
                    xd = []
                    modecolor=pl[-1].get_color()
                    for ii in range(len(x)-1):
                        li = x[ii+1] - x[ii]
                        xx = np.linspace(li/10, li, 10)
                        y.append( 
                            NT1(xx,li)*yn[ii]+\
                            NT2(xx,li)*thetan[ii]+\
                            NT3(xx,li)*yn[ii+1]+\
                            NT4(xx,li)*thetan[ii+1]
                        )
                        xd.append(xx+x[ii])
                    y = np.array(y).ravel() 
                    xd = np.array(xd).ravel()
                    pi.append(axM[l].plot(xd, y, ':',color=modecolor ))
                #caselabel.append('Interpolacion'))
            axM[l].legend(labels=[], title=labels[l], loc='upper left')
        axM[-1].set_ylabel(r'$\Delta y$')
        axM[-1].set_xlabel('x')
        figM.legend(handles=pl,
                labels=caselabel,
                ncol=len(caselabel), 
                loc='upper center',
                bbox_to_anchor=(0.53, 0.96))
        plt.savefig(name+'Modo_{}.pdf'.format(M))
#        plt.close()


# plotmodes(MODES, [2, 6, 10], dv, labels, 'transversales')
# plotfrecs(ws, cases, name)
