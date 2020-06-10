import matplotlib.pyplot as plt


def plotfrecs(ws, cases):
    maxmode=len(ws[1])
    ncases = len(cases)
    fig, ax = plt.subplots( maxmode, 1,  figsize=(8, 20), sharex=True)
    for M in range(maxmode):
        axnum = maxmode-M-1
        for i in len(cases):
            l1 = ax[axnum].plot(ws[i][:, M], 'o-b', label=cases[i])[0]
            ax[axnum].legend(labels=[], title='modo {:d}'.format(M+1), loc='upper right')
    ax[-1].set_xlabel('Numero de nodos')
    ax[int(maxmode/M)].set_ylabel('frecuencia(Hz)')
    fig.legend([l1, l2],
            labels=cases,
            loc='upper center',
            ncol=2
            ),
#        loc='upper center', bbox_to_anchor=(0.2, 1.5), mode='expand')
    plt.savefig('frecuencias'+''.join(cases)+'.pdf')
    plt.close()

def plotmodes(MODES, cases, labels):
    maxmode = len(MODES[0])
    ncases = len(cases)
    for M in range(maxmode):
        figM, axM = plt.subplots(ncases,1, sharex=True)
        for l in range(len(labels)):
            for i in range(ncases):
                axM[l].plot(MODES[l][:, cases[i]], 'o-')



