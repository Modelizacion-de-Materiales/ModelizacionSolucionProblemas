from numpy import *
from matplotlib import *
import tycc
import valcc
import geo

print tycc.derecha , " derecha = " , valcc.derecha
print tycc.izquierda , " izquierda = " , valcc.izquierda
print tycc.abajo , " abajo = " , valcc.abajo
print tycc.arriba , " arriba = ", valcc.arriba

beta = geo.Lx / geo.Ly

print "beta =", beta

# lo primero que tengo que hacer es armar la matriz
# las ecuaciones eran 
# Para los puntos interiores:
# A(i, [i - Nx, i-1, i+1, i+Nx ]) = [beta^2 , 1, -2*(1+beta^2), 1, beta^2]
# 
# Para los puntos con temperatura constante
# A(i,i) = 1.0
# Para los puntos de abajo con flujo nulo
# A(i,i-1,i,i+1,i+Nx) = 1, -2*(1+beta^2), 2.0, beta^2

allnods=linspace(0,geo.Nx*geo.Ny-1, geo.Nx*geo.Ny).astype(int)
# que dios me calcule los vertices :
vertices=(0,geo.Nx-1,geo.Nx*(geo.Ny-1),geo.Nx*geo.Ny-1)
print "los vertices son ", vertices
# paso
A=zeros([geo.Nx*geo.Ny,geo.Nx*geo.Ny^2])
B=zeros([geo.Nx*geo.Ny,1])

#borde de abajo
kc=linspace(vertices[0], vertices[1],geo.Nx ).astype(int)
#borde de arriba
kd=linspace(vertices[2], vertices[3],geo.Nx ).astype(int)
#borde de la izquierda
ka=linspace(vertices[0], vertices[2],geo.Ny ).astype(int)
#borde de la derecha
kb=linspace(vertices[1], vertices[3],geo.Ny ).astype(int)

print " todos los nodos :" , allnods
print "ka=", ka
print "kb=", kb
print "kc=", kc
print "kd=", kd

for k in allnods:
# primero tengo que ver si el punto esta en los vertices. 
    if ( k in ka )and(k in kc): # vertice infrior izquierdo
        print k, "es vertie vertice inferior izquierdo ==="
        print tycc.izquierda , tycc.abajo
        if (tycc.izquierda.find("temp")!=-1)and(tycc.abajo.find("temp")!=-1):
            print "temperatura izquierda y abajo"
            A[k,k]=+1.0
            B[k]=+(valcc.izquierda+valcc.derecha)/2.0
        elif (tycc.izquierda.find("flujo")!=-1)and(tycc.abajo.find("flujo")!=-1):
            print "flujo en izquierda y abajo"
            A[k,k]=    -2.0*(1.0 - beta**2)
            A[k,k+1]=  2.0
            A[k,k+Nx]= 2.0 
            B[k] = 0.5*(valcc.izquierda+valcc.abajo)
        elif tycc.izquierda.find("temp")!=-1:
            print "temperatura izquierda"
            A[k,k] = +1.0
            B[k] = valcc.izquierda
        elif tycc.abajo.find("temp")!=-1:
            print "temperatura abajo"
            A[k,k] = +1.0
            B[k] = valcc.abajo

    elif (k in kc) and (k in kb):
        print k, " es vertice inferior derecho "
        print ttcc.abajo, tycc.abajo
        if (tycc.abajo.find("temp")=-1)and (tycc.derecha.find("temp")):
            print "temperatura  abajo y derecha"

            A[k,k]=+1.0
            B[k] = 0.5*(valcc.derecha + valcc.abajo)
        elif (tycc.izquierda.find("flujo")!=-1)and(tycc.arriba.find(flujo)!=-1):
            A[k,k]=    -2.0*(1.0 - beta**2)
            A[k,k-1]=  2.0
            A[k,k+Nx]= 2.0 
            B[k] = 0.5*(valcc.izquierda+valcc.derecha)
        elif tycc.derecho.find("temp"):
            A[k,k]=1.0
            B[k] = valcc.derecha
        elif tycc.abajo.find("temp"):
            A[k,k]=1.0
            B[k] = valcc.abajo

    elif (k in ka) and (k in kd):
        print k, " es vertice superior izquierdo "
        print tycc.arriba, tycc.izquierda 
        if (tycc.arriba.find("temp")=-1)and (tycc.izquierda.find("temp")):
            print "temperatura  abajo y derecha"
            A[k,k]=1
            b[k] = 0.5*(valcc.arriba + valcc.izquierda):
        elif (tycc.arriba.find("flujo")!=-1)and (tycc.izquierda.find("flujo")!=-1):
            A[k,k] = -2.0*(1.0-beta**2)
            A[k,k-1]=2.0
            A[k,k-Nx]=2.0
            B[k] = 0.5*(valcc.arriba+valcc.izquierda)
        elif (tycc.arriba.find("temp")!=-1):
            A[k,k]=1.0
            B[k]=valcc.arriba
        elif (tycc.izquierda.find("temp")!=-1):
            A[k,k]=1.0
            B[k] = valcc.izquierda

    elif (k in kb) and (k in kd):
        print k, " es vertice superior derecho "
        print tycc.arriba, tycc.derecha
        if (tycc.arriba.find("temp")!=-1)and(tycc.derecha.find("temp")!=-1):
            print " teperatura arriba y a la derecha"
            A[k,k] = 1.0
            B[k] = 0.5*( valcc.arriba + valcc.derecha):
        elif (tycc.arriba.find("flujo")!=-1)and(tycc.derecha.find("flujo")!=-1): 
            print "flujo arriba y a la izquierda"
            A[k,k]=-2.0*(1.0-beta**2)
            A[k,k-1]=2.0
            A[k,k-Nx]=2.0
            B[k] = 0.5*( valcc.arriba + valcc.derecha)
        elif (tycc.arriba.find("temp")!=-1):
            A[k,k]=1
            B[k] = valcc.arriba
        elif (tycc.derecha.find("temp")!=-1):
            A[k,k]=1
            B[k,k] = valcc.derecha
# terminan los vertices, empiezo con los bordes. 
    elif k in ka:
        print k, "borde izquierda"
        if (tycc.izquierda.find("flujo")!=-1):
            A[k,k]=-2.0*(1.0-beta**2)
            A[k,k+1]=2.0
            A[k,k-Nx]=1.0
            A[k,k+Nx]=2.0
        elif (tycc.izquierda.find("temp")!=-1):
            A[k,k]=1.0
        B[k] = valcc.izquierda
    elif k in kb:
        print k ,"borde derecha"
        if (tycc.derecha.find("flujo")!=-1):
            A[k,k]=-2.0*(1.0-beta**2)
            A[k,k-1]=2.0
            A[k,k-Nx]=1.0
            A[k,k+Nx]=2.0
        elif (tycc.derecha.find("temp")
            A[k,k]=1.0
        B[k]=valcc.derecha

    elif k in kc:
        print k ,"borde abajo"
        if (tycc.abajo.find("flujo")!=-1):
            A[k,k]=-2.0*(1.0-beta**2)
            A[k,k-1]=1.0
            A[k,k+1]=1.0
            A[k,k+Nx]=2.0
        elif (tycc.abajo.find("temp")
            A[k,k]=1.0
        B[k]=valcc.abajo
    elif k in kd:
        print k ,"borde de arriba"
        if (tycc.abajo.find("flujo")!=-1):
            A[k,k]=-2.0*(1.0-beta**2)
            A[k,k-1]=1.0
            A[k,k+1]=1.0
            A[k,k+Nx]=2.0
        elif (tycc.abajo.find("temp")
            A[k,k]=1.0
        B[k]=valcc.abajo
        
