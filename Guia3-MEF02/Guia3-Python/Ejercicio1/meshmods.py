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
        self.elements = [np.array(alist) for alist in elements]
        self.physnames = physnames
        self.physcodes = physcodes
        self.MN = MN
        self.MC = np.array(elements[-1])
        return elements

    def writemsh(self, filename):
        fo = open(filename, 'w')
        fo.write('$MeshFormat\n2.2 0 8\n$EndMeshFormat\n')
        fo.write('$Nodes\n')
        fo.write('{:d}\n'.format(len(self.MN)))
        for n in range(len(self.MN)):
            line = '{:d} '.format(n+1)
            for x in self.MN[n, :]:
                line += ' {:f}'.format(x)
            line += '\n'
            fo.write(line)
        fo.write('$EndNodes\n')
        fo.write('$Elements\n')
        fo.write('{:d}\n'.format(len(self.MC)))
        for e in range(len(self.MC)):
            line = '{:d} 2 0 '.format(e+1)
            for n in self.MC[e]:
                line += ' {:d}'.format(n)
            fo.write(line+'\n')
        fo.write('$EndElements\n')
        fo.close()

    def writedatablock(self, filename, data, title, itime, time, dim=3, blocktype='NodeData'):
        fo = open(filename, 'a')
        fo.write('$'+blocktype+'\n')
        fo.write('1\n'+title+'\n')
        fo.write('1\n'+'{:f}\n'.format(time))
        fo.write('3\n{:d}\n{:d}\n{:d}\n'.format(
                itime,
                dim,
                len(data)
                )
            )
        for i in range(len(data)):
            line = '{:d} '.format(i+1)
            if dim > 1:
                for d in data[i]:
                    line += ' {:f}'.format(d)
            else:
                line += ' {:f}'.format(data[i])
            line += '\n'
            fo.write(line)
        fo.write('$End'+blocktype+'\n')
        fo.close()

