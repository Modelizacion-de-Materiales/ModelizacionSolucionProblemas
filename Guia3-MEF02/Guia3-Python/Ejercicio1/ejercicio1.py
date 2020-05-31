#!/usr/bin/python3
# -*- coding: utf8 -*-
from meshmods import mesh
chapa = mesh()
chapa.readmsh('chapa-test.msh')
partes = chapa.getnames()
print(chapa.MC)
print(chapa.MN)
print(chapa.physcodes)
print(chapa.physnames)
