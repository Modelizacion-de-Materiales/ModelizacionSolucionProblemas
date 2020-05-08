#!/usr/bin/env  python3
# -*- coding: utf-8 -*-
import numpy as np
import sys
sys.path.append("../")
import pdb
from scipy.integrate import quad
import mefmods as mef
import matplotlib.pyplot as plt
import os.path
#import matplotlib
#matplotlib.use('Qt5Agg')


class Esclaon(object):

    def __init__(self, filein='Esclaon.ge', case='Escalon'):
        self.case = case
        self.GL,\
                self.MC,\
                self.MN,\
                self.MP,\
                self.ET,\
                self.VINS = mef.getgeo(filein)
        self.K = mef.ensamble(
            self.MC,
            self.MN,
            self.MP,
            self.GL,
            self.ET,
            'Trampolin')
        self.R, self.S, self.US, self.FR = mef.makevins(self.GL, len(self.MN), self.VINS)
        self.W = -200 # lb / ft
        self.FR += self.W*15*np.array([ -1/2., -15/12., -1/2., 15/12.])
        self.U, self.F = mef.resolvermef(self.R, self.S, self.K, self.US, self.FR, self.case)


T = trampolin()
UM = mef.makenodex(T.U, T.GL, 3, len(T.MN))
UM[:, 1] = UM[:, 0]
UM[:, 0] = 0.
FM = mef.makenodex(T.F, T.GL, 3, len(T.MN))
FM[:, 1] = FM[:, 0]
FM[:, 0] = 0.

mef.plotmesh(T.MC, T.MN, FM, UM, 'trampolin', scale=10)
