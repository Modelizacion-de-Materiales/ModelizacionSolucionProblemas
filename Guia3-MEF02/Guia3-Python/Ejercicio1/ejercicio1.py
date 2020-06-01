#!/usr/bin/python3
# -*- coding: utf8 -*-
from meshmods import mesh
import mefmods as mef
CHAPA = mesh('chapa-test.msh')
CHAPA.newreadmsh()
MC = CHAPA.elements[CHAPA.physnames.index('"sheet"')]
LEMB = CHAPA.elements[CHAPA.physnames.index('"embedded"')]
LSTRE = CHAPA.elements[CHAPA.physnames.index('"stress"')]
print(len(CHAPA.MN))
# print(CHAPA.elements)
# print(CHAPA.MN)
# print(CHAPA.physcodes)
# print(CHAPA.physnames)
