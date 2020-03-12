# Programa Ejercico 1 _ Guia 1 2017 ; (c) Mariano Forti
# numpy se instala en ubuntu como python-numpy
#matplotlib se instala en ubuntu como python-matplotlib
import numpy as np
import matplotlib.pyplot as plt
# from numpy import *
#from matplotlib.pyplot import *


def misplines(XSPLINE,YSPLINE,fun_name_spline):
    """
    Esto es un comentario multilinea
    def es la palabra clave para las funciones. las indentaciones son las que marcan comienzo y fin
    de funciones y otros statements. 

    INPUTS: 

    XSPLINE : coordenadas X para interpolar. 

    YSPLINE : coordenadas Y para interpolar.

    fun_name_spline: nombre de la instancia a interpolar. por ejemplo, 'funcion' , 'derivada' , 'derivadasegunda' 

    """

    NX=len(XSPLINE)
    h=np.diff(XSPLINE).astype(float)  # diff se importa de numpy.
    A=np.matrix(np.identity(NX)).astype(float)    # matrix se importa de numpy. las operaciones se interpretan entre matrices.
    YY=np.matrix(np.zeros([NX,1])).astype(float)
    for i in np.linspace(1,NX-2,NX-1).astype(int):
        """
        como antes, la indentacion marca la pertenencia a los statements. 
        crear estos vectores sin el + adelante crea una especie de puntero. para que los valores se guarden de verdad 
        en memoria hay que asignar con el mas. 

        """
        A[i,[i-1,i,i+1]]=+np.array([h[i-1],2*(h[i]+h[i-1]),h[i]]) # Los rangos no incluyen el limite superior.
                                                               # por eso i-1:i+1 no funciona!
        YY[i]=+3.0*( ( YSPLINE[i+1]-YSPLINE[i])/h[i] - (YSPLINE[i]-YSPLINE[i-1])/h[i-1] ) 
                                  
 
    B=np.linalg.solve(A,YY)  # linalg se importa de numpy. linalg.solve resuelve el sistema lineal AA*B=YY.
    a=np.zeros([N-1,1])
    c=np.zeros([N-1,1])
    b=np.zeros([N-1,1])
    d=np.zeros([N-1,1])

    # una vez que tengo las b, resuelvo recursivamente las otras cosas.
    for i in np.linspace(0,N-2,N-1).astype(int):
        a[i]=(1.0/3.0) * ( B[i+1] - B[i] ) / h[i]
        c[i]=(YSPLINE[i+1]-YSPLINE[i])/h[i] - B[i]*h[i] - a[i]*( h[i]**2 )
        b[i]=B[i,0]
        d[i]=YSPLINE[i]

#    guardar en archivos (concatenacion)
    afile='a'+fun_name_spline+'.txt'
    bfile='b'+fun_name_spline+'.txt'
    cfile='c'+fun_name_spline+'.txt'
    dfile='d'+fun_name_spline+'.txt'
    YYfile='YY'+fun_name_spline+'txt'

    np.savetxt(afile,a)
    np.savetxt(bfile,b)
    np.savetxt(cfile,c)
    np.savetxt(dfile,d)
    np.savetxt(YYfile,YY)

    # devolver la salida y terminar la funcion:
    return a,b,c,d 

def derivar(XDERIVAR,YDERIVAR):
    """
    Esta funcion deriva numericamente una lista de datos dada, que deben entregarse como dos np.array distintos.
    XDERIVAR: coordenadas x
    YDERIVAR :  etc
    """

    NX= len(XDERIVAR)
    NY = len(YDERIVAR)
    dYDERIVAR = np.zeros([NX,1])
    #    Acá podría ser posible dar un error ante una diferencias de tamaños.
    # Derivada en el primer punto es un cociente incremental a la derecha
    dYDERIVAR[0] =[ (YDERIVAR[1]-YDERIVAR[0])/(XDERIVAR[1]-XDERIVAR[0]) ]
    for i in np.linspace(1,NX-2,NX-2).astype(int):
        # En los puntos internos , la derivada es centrada
        dYDERIVAR[i]=((YDERIVAR[i+1]-YDERIVAR[i-1])/(XDERIVAR[i+1]-XDERIVAR[i-1]))
        # Derivada en el último  punto es un cociente incremental a la izquierda
    dYDERIVAR[N-1]=( [ (YDERIVAR[NX-1]-YDERIVAR[NX-2])/(XDERIVAR[NX-1]-XDERIVAR[NX-2]) ] )

    # la funcion devuelve solo las coordenadas Y

    return dYDERIVAR




z,T = np.loadtxt('DATA.txt',unpack=True) # loadtxt se importa de numpy
    
print ("Z = ", z)
print ("T = ", T)


N=len(z)
print( "N = ", N)


a,b,c,d = misplines(z,T,'funcion')

dT = derivar(z,T)
da,db,dc,dd=misplines(z,dT,'derivada')

ddT=derivar(z,dT)
dda,ddb,ddc,ddd=misplines(z,ddT,'derivadasegunda')

"""
el grafico se va armando sin mostrar hasta que se pide explicitamente.
pyplot.plot funciona como el plot de matlab , grafica vectores. 
notar que se importa de matplotlib.pyplot
"""

plt.plot(z,T,'ok',ms=8,label="Mediciones")
plt.plot(z,dT,'or',ms=8,label="Primera Derivada")
plt.plot(z,ddT,'og',ms=8,label="Segunda Derivada")

for i in np.linspace(0,N-2,N-1).astype(int):
    zi=np.linspace(z[i],z[i+1],10).astype(float)
#funcion:
    Ti=a[i]*(zi-z[i])**3+b[i]*(zi-z[i])**2+c[i]*(zi-z[i]) +d[i]
# Derivada:
    dTi=da[i]*(zi-z[i])**3+db[i]*(zi-z[i])**2+dc[i]*(zi-z[i]) +dd[i]
#Derivada Segunda:
    ddTi=dda[i]*(zi-z[i])**3+ddb[i]*(zi-z[i])**2+ddc[i]*(zi-z[i]) +ddd[i]
#plot:
    plt.plot(zi,Ti,'--k',zi,dTi,'--r',zi,ddTi,'--g')  # plot es importada de matplotlib.pyplot


plt.legend(loc='best')
plt.title("La funcion T vs z y las derivadas interpoladas")
plt.xlabel ("z (m)")
plt.savefig('Tvsz.png')
plt.show()



