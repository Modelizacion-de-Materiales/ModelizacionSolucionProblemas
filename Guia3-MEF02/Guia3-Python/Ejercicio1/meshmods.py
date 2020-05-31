#!/usr/bin/python3.6
# -*- encoding utf8 -*-
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

    def __init__(self, dim=2, mshformat=2.2):
        self.out = outfile 
        self.dim = dim
        self.mshformat = mshformat

    def readmsh(self, meshfile,  etype=2):
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
        fi = open(self.meshfile, 'r')
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
    
    def getmeshboundaries(self, boundkinds):
        nbounds = len(boundkinds)
        fi = open(self.meshfile)
        lines = fi.readlines()
        fi.close()
        l = 0
        physnames = []
        physcodes = []
        while l < len(lines):
           if '$PhysicalNames' in line:
               l += 1
               nnames = int(lines[l])
               for i in range(nnames):
                   l += 1
                   info = lines[l].split()
                   physcodes.append(info[:1])
                   physnames.append(info[-1])





        

