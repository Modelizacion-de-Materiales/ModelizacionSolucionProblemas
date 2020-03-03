from numpy import *
from matplotlib.pyplot import *
import tycc
import valcc
import geo
from MakeA import *


vertices=(0,geo.Nx-1,geo.Nx*(geo.Ny-1),geo.Nx*geo.Ny-1)
#borde de abajo
kc=linspace(vertices[0], vertices[1],geo.Nx ).astype(int)
#borde de arriba
kd=linspace(vertices[2], vertices[3],geo.Nx ).astype(int)
#borde de la izquierda
ka=linspace(vertices[0], vertices[2],geo.Ny ).astype(int)
#borde de la derecha
kb=linspace(vertices[1], vertices[3],geo.Ny ).astype(int)

# Solucion
A,B = makeA(ka,kb,kc,kd,geo,tycc,valcc)

T=linalg.solve(A,B)
Tmat=zeros([geo.Nx,geo.Ny])
for i in linspace(0,geo.Nx-1,geo.Nx).astype(int):
    for j in linspace(0,geo.Ny-1,geo.Ny).astype(int):
        k=i+j*geo.Nx
        Tmat[j,i]=T[k]

# solo para graficar
x=linspace(0,geo.Lx,geo.Nx).astype(float)
y=linspace(0,geo.Ly,geo.Ny).astype(float)
X,Y=meshgrid(x,y)

CS=contourf(X,Y,Tmat)
CS2=contour(CS,levels=CS.levels,colors='k',linewidth=5)
xlabel('X')
ylabel('Y')
cbar=colorbar(CS,ticks=linspace(min(T),max(T),10),boundaries=[min(T),max(T)])
cbar.ax.set_ylabel('Temperature')

savetxt('Temps.dat',T)
savetxt('Temp_mat.dat',Tmat)


# Ahora tengo que calcular los flujos. 
# dTx, dTy= gradient(Tmat)
dTy, dTx = migrad(Tmat)
print dTx , dTy
# VX,VY = meshgrid(which_plot_x,which_plot_y)
streamplot(X,Y,-dTx,-dTy,color='k',linewidth=3,density=1)

show()

