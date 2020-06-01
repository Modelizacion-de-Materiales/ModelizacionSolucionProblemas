#!/usr/bin/python3.6
# -*- coding: utf8 -*-
import numpy as np
import pdb

class mesh(object):
    """
    class mesh
    =========
    interface con objetos mesh leídos desde gmsh.

    métodos:
    =================
    readmsh(file): define atributos del mallado: MC, MN, etc
    writemsh(mesh.MC, mesh.MN): guarda un mallado dado por sus matrices
    writedatablock(file, data): agrega data a un mallado existente
    mkvins([physgroups, vintypes]): genera los vectores rs segun los vintypes en los phusgroups (listas)


    atributes:
    =================
    MC: matriz de conectividad
    MN: matriz de nodos
    R: vector de incognitas
    S: grados de libertad vinculados
    F: lista de fuerzas externas
    U: desplazamientos vinculados
    """

    def __init__(self, meshfile, dim=2, mshformat=2.2):
        self.dim = dim
        self.mshformat = mshformat
        self.meshfile = meshfile

    def readmsh(self,  etype=2):
        """
        devuelve matriz de nodos y de conectividad
        para el archivo msh leído
        """
        if etype == 2:  # triangulos 2D
            self.NNXEL = 3
            self.GL = 2
        else:   # supongo lineas
            self.NNXEL = 2
            self.GL = 2
        fi = open(meshfile, 'r')
        for line in fi:
            if '$Nodes' in line:
                NNODES = np.int(
                        fi.readline().strip(),
                        )
                MN = np.zeros((NNODES, 3))
                for n in range(NNODES):
                    MN[n, :] = np.fromstring(
                             fi.readline().strip(),
                             dtype=float,
                             sep=' '
                             )[-3:]
                self.MN = MN
            if '$Elements' in line:
                nelem = np.int(
                        fi.readline().strip()
                        )
                MC = []
                for e in range(nelem):
                    aux = np.fromstring(
                            fi.readline().strip(),
                            dtype=int,
                            sep=' ')
                    if aux[1] == 2:
                        MC.append(aux[-self.NNXEL:])
                self.MC = np.array(MC)
                self.NEL = self.MC.shape[0]
        fi.close()
        self.meshfile = meshfile

    def getnames(self):
        # fi = open(self.meshfile)
        physnames = []
        physcodes = []
        physdim = []
        for line in fi:
            if '$PhysicalNames' in line:
                nnames = int(fi.readline())
                for i in range(nnames):
                    info = fi.readline().split()
                    physcodes.append(info[1])
                    physnames.append(info[-1])
                    physdim.append(info[0])
                break
        self.physnames = physnames
        self.physcodes = physcodes
        self.physdim = physdim

    def newreadmsh(self):
        fi = open(self.meshfile)
        physnames = []
        physcodes = []
        physdim = []
        elements = []
        for line in fi:
            if '$PhysicalNames' in line:
                nnames = int(fi.readline())
                for i in range(nnames):
                    info = fi.readline().split()
                    physcodes.append(info[1])
                    physnames.append(info[-1])
                    physdim.append(info[0])
                    elements.append([])
            if '$Nodes' in line:
                NNODES = np.int(
                        fi.readline().strip(),
                        )
                MN = np.zeros((NNODES, 3))
                for n in range(NNODES):
                    MN[n, :] = np.fromstring(
                             fi.readline().strip(),
                             dtype=float,
                             sep=' '
                             )[-3:]
                self.MN = MN
            if '$Elements' in line:
                totale = int(fi.readline().strip())
                for e in range(totale):
                    info = [int(i) for i in fi.readline().strip().split()]
                    # i, etype, ntags, info = 
                    elements[info[3]-1].append(info[3+info[2]:])
        self.elements = elements
        self.physnames = physnames
        self.physcodes = physcodes
        self.MN = MN
        return elements
                    

 
