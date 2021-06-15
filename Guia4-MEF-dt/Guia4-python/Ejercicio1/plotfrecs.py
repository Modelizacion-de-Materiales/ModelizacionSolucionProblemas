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
    plt.savefig('frecuencias'+name+'.pdf')
    # plt.close()


def plotmodes(MODES, cases, dv, labels, name, glstep=2, fig_size=(7, 10)):
    maxmode = MODES[0][-1][-1].shape[1]
    xv = np.linspace(0, 1, dv[::glstep].shape[0])
    Figs = []
    for M in range(maxmode):
        # M para los modos
        figM, axM = plt.subplots(len(labels), 1, sharex=True, figsize=fig_size)
        figM.subplots_adjust(
                hspace=0.05,
                top=0.8,
                left=0.15,
                right=0.95
                )
        # detalles del grafico
        # axM[-1].set_ylabel(r'$\Delta y$')
        axM[0].annotate(r'$\Delta y$',
                (0.05, 0.81), xycoords='figure fraction',
                xytext=(0,0),
                textcoords='offset points',
                rotation=0,
                fontsize=16
                )
        axM[-1].set_xlabel('x', fontsize=16)
        figM.suptitle('modo {}'.format(M+1))
        for l in range(len(labels)):
            # l para el label -> MODE[l][][M]
            pl = []
            pi = []  # lineas de interpolacion
            caselabel = []
            pl.append(axM[l].plot(xv, dv[::glstep, M]/dv[-glstep, M])[0])
            caselabel.append('{}'.format(xv.shape[0]))
            for i, case in enumerate(cases):
                if M < 2*case:  # Si M > 2*case entonces no se pudo resolver el modo
                    x = np.linspace(0, 1, case+1)
                    # vars para el desplazamiento y el angulo nodal, normalizados. 
                    yn = MODES[l][case-1][0][::glstep, M]/MODES[l][case-1][0][-2, M]
                    thetan = MODES[l][case-1][0][1::glstep, M]/MODES[l][case-1][0][-2, M]
                    pl.append(axM[l].plot(x, yn, 'o')[0])
                    caselabel.append('{}'.format(case+1))
                    # dos variables densas para la interpolación
                    y = []
                    xd = []
                    # quiero que la interpolación me qude del mismo color que los puntos
                    modecolor = pl[-1].get_color()
                    # ahora armo la interpolación
                    for ii in range(len(x)-1):
                        li = x[ii+1] - x[ii]
                        xx = np.linspace(li/10, li, 10)
                        # las funciones de nterpolacion son las de las 
                        # vigas de mefmod
                        y.append(
                            NT1(xx, li)*yn[ii] +
                            NT2(xx, li)*thetan[ii] +
                            NT3(xx, li)*yn[ii+1] +
                            NT4(xx, li)*thetan[ii+1]
                        )
                        xd.append(xx+x[ii])
                    y = np.array(y).ravel() 
                    xd = np.array(xd).ravel()
                    pi.append(axM[l].plot(xd, y, ':', color=modecolor))
            # finalmente agrego los titulos de los modos graficados
            axM[l].legend(labels=[], title=labels[l], loc='upper left')
#        axM[-1].set_ylabel(r'$\Delta y$')
        # y por útlimo, no menos importante, la leyenda con los nodos dibujados
        # esto tengo que arreglarlo porque si hago mas de dos dibujos se me 
        # sale del grafico
        figM.legend(
                handles=pl,
                labels=caselabel,
                ncol=len(caselabel), 
                loc='upper center',
                bbox_to_anchor=(0.5, 0.95),
                title='Nodos:'.format(M)
                )
        Figs.append(figM)
        figM.savefig(name+'Modo_{}.pdf'.format(M))
    return Figs
        #plt.close()


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
    plt.savefig(name+'allmodes.pdf')
    return fig
    #plt.close()


