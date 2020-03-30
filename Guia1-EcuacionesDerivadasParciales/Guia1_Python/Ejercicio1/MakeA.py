from numpy import *
import numpy as np

def makeA( KA, KB, KC, KD ,GEO, TYCC, VALCC ):

   allnods = linspace(0,GEO.Nx*GEO.Ny-1, GEO.Nx*GEO.Ny).astype(int) 
   vertices=(0,GEO.Nx-1,GEO.Nx*(GEO.Ny-1),GEO.Nx*GEO.Ny-1)
   A=np.zeros([GEO.Nx*GEO.Ny,GEO.Nx*GEO.Ny])
   B=zeros([GEO.Nx*GEO.Ny,1])
   beta = GEO.Lx / GEO.Ly

   
   for k in allnods:
   # primero tengo que ver si el punto esta en los vertices. 
       if ( k in KA )and(k in KC): # vertice infrior izquierdo
           if (TYCC.izquierda.find("temp")!=-1)and(TYCC.abajo.find("temp")!=-1):
               A[k,k]=+1.0
               B[k]=+(VALCC.izquierda+VALCC.derecha)/2.0
           elif (TYCC.izquierda.find("flujo")!=-1)and(TYCC.abajo.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k+1]= 2.0
               A[k,k+GEO.Nx]=2.0*beta**2
               B[k] = 0.5*(VALCC.izquierda+VALCC.abajo)
           elif TYCC.izquierda.find("temp")!=-1:
               A[k,k] = +1.0
               B[k] = VALCC.izquierda
           elif TYCC.abajo.find("temp")!=-1:
               A[k,k] = +1.0
               B[k] = VALCC.abajo
   
       elif (k in KC) and (k in KB):
           if (TYCC.abajo.find("temp")!=-1)and (TYCC.derecha.find("temp")!=-1):
               A[k,k]=+1.0
               B[k] = 0.5*(VALCC.derecha + VALCC.abajo)
           elif (TYCC.izquierda.find("flujo")!=-1)and(TYCC.arriba.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k-1]=2.0
               A[k,k+GEO.Nx]= 2.0*beta**2
               B[k] = 0.5*(VALCC.izquierda+VALCC.derecha)
           elif TYCC.derecha.find("temp")!=-1:
               A[k,k]=1.0
               B[k] = VALCC.derecha
           elif TYCC.abajo.find("temp")!=-1:
               A[k,k]=1.0
               B[k] = VALCC.abajo
       elif (k in KA) and (k in KD):
           if (TYCC.arriba.find("temp")!=-1)and (TYCC.izquierda.find("temp")!=-1):
               A[k,k]=1.0
               B[k] = 0.5*(VALCC.arriba + VALCC.izquierda)
           elif (TYCC.arriba.find("flujo")!=-1)and (TYCC.izquierda.find("flujo")!=-1):
               A[k,k] = -2.0*(1.0+beta**2)
               A[k,k-1]=2.0
               A[k,k-GEO.Nx]=2.0*beta**2
               B[k] = 0.5*(VALCC.arriba+VALCC.izquierda)
           elif (TYCC.arriba.find("temp")!=-1):
               A[k,k]=1.0
               B[k]=VALCC.arriba
           elif (TYCC.izquierda.find("temp")!=-1):
               A[k,k]=1.0
               B[k] = VALCC.izquierda
       elif (k in KB) and (k in KD):
           if (TYCC.arriba.find("temp")!=-1)and(TYCC.derecha.find("temp")!=-1):
               A[k,k] = 1.0
               B[k] = 0.5*( VALCC.arriba + VALCC.derecha)
           elif (TYCC.arriba.find("flujo")!=-1)and(TYCC.derecha.find("flujo")!=-1): 
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k-1]=2.0
               A[k,k-GEO.Nx]=2.0*beta**2
               B[k] = 0.5*( VALCC.arriba + VALCC.derecha)
           elif (TYCC.arriba.find("temp")!=-1):
               A[k,k]=1
               B[k] = VALCC.arriba
           elif (TYCC.derecha.find("temp")!=-1):
               A[k,k]=1
               B[k] = VALCC.derecha
   # terminan los vertices, empiezo con los bordes. 
       elif k in KA: # borde de la izqujierda
           if (TYCC.izquierda.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k+1]=2.0
               A[k,k-GEO.Nx]=beta**2
               A[k,k+GEO.Nx]=beta**2
           elif (TYCC.izquierda.find("temp")!=-1):
               A[k,k]=1.0
           B[k] = VALCC.izquierda
       elif k in KB:  # borde de la derecha.
           if (TYCC.derecha.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k-1]=2.0
               A[k,k-GEO.Nx]=beta**2
               A[k,k+GEO.Nx]=beta**2
           elif (TYCC.derecha.find("temp")!=-1):
               A[k,k]=1.0
           B[k]=VALCC.derecha
   
       elif k in KC: # borde de abajo
           if (TYCC.abajo.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k-1]=1.0
               A[k,k+1]=1.0
               A[k,k+GEO.Nx]=2.0*beta**2
           elif (TYCC.abajo.find("temp")!=-1):
               A[k,k]=1.0
           B[k]=VALCC.abajo
       elif k in KD:
           if (TYCC.arriba.find("flujo")!=-1):
               A[k,k]=-2.0*(1.0+beta**2)
               A[k,k-1]=1.0
               A[k,k+1]=1.0
               A[k,k-GEO.Nx]=2.0*beta**2
           elif (TYCC.arriba.find("temp")!=-1):
               A[k,k]=1.0
           B[k]=VALCC.arriba
       else:
           A[k,k] = -2.0*(1.0+beta**2)
           A[k,k-1]=1.0
           A[k,k+1]=1.0
           A[k,k+GEO.Nx]=beta**2
           A[k,k-GEO.Nx]=beta**2
   
   savetxt('MatrizA.dat',A,fmt='%.3e  ')
   return A, B

def migrad(MAT):
    
    N,M = shape(MAT)
    #print ( N,M )

# 1 es la derivada en x
    D1 = zeros([N,M])
# 2 es la derivada en y    
    D2 = zeros([N,M])

# Primero armo las derivadas en x:
    D1[1,:]=MAT[1,:]-MAT[2,:]
    for i in linspace(1,N-2,N-1).astype(int):
      D1[i,:]=(MAT[i+1,:]-MAT[i-1,:])/2
    D1[-1,:]=-(MAT[-1,:]-MAT[-2,:])
# y ahora las derivadas en y    
    D2[1,:]=MAT[:,1]-MAT[:,2]
    for i in linspace(1,N-2,N-1).astype(int):
      D2[:,i]=(MAT[:,i+1]-MAT[:,i-1])/2
    D1[:,-1]=-(MAT[:,-1]-MAT[:,-2])
    

    return D1, D2


    
