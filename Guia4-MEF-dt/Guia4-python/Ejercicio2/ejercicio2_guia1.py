#!/usr/bin/env python3
# vim: source ~/.vim/ftplugin/python.vim

import pdb
import numpy as np
# import matplotlib
# matplotlib.use('Qt5agg')
import matplotlib.pyplot as plt


def plotlistT(theTlist, dt):
    TS = np.loadtxt(theTlist).transpose()
    N, NT = np.shape(TS)
    losTs1 = np.linspace(0, (NT-1)/3, 5).astype(int)
    # losTs2 = np.linspace((NT-1)/3+1, NT-1, 3).astype(int)
    losTags1 = [r'$t =$ {:.1f}'.format(val*dt) for val in losTs1]
    losTs1 = np.append(losTs1, NT-1)
    losTags1.append(r'$t = ${:.1f}'.format(NT*dt))
    lostagsy = [y+1 for y in TS[np.int(N/2)-1, losTs1]]
    lostagsy.append(TS[np.int(N/2-1), NT-1])  # el ultimo tag
    lostagsx = [np.int(N/2) for i in range(len(lostagsy))]
    plt.plot(TS[:, losTs1], '--ok')
    for i in range(len(losTags1)):
        segmentoy = np.array([
            TS[lostagsx[i], losTs1[i]],
            TS[lostagsx[i]+1, losTs1[i]]
            ])
        rot = np.array(
                [(180/np.pi)*np.arctan2(TS[-1, losTs1[i]] - TS[-2, losTs1[i]], 1)]
                )
        textloc = np.array([lostagsx[i], segmentoy[1]])
        realrot = plt.gca().transData.transform_angles(
                rot, textloc.reshape((1, 2))
                )[0]
        plt.text(lostagsx[i]-1, lostagsy[i], losTags1[i], rotation=realrot)  # rot*45/(np.pi/4.))
    plt.xlabel('X')
    plt.title(r'$\delta t = {:.2f}$'.format(dt))
    plt.ylabel(r'T ($^{o}C$)')
    plt.xlim(0, N-1)
    plt.show()
    figfile = theTlist.replace('.dat', '.pdf')
    plt.savefig(figfile)
    plt.close()
