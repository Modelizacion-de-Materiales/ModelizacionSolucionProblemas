
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


class trampolin(object):

    def __init__(self, filein='Trampolin.ge', case='Trampolin'):
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
        pdb.set_trace()
        self.U, self.F = mef.resolvermef(self.R, self.S, self.K, self.US, self.FR, self.case)


T = trampolin()
