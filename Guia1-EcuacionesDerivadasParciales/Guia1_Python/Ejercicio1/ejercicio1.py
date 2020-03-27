import numpy as np
import matplotlib.pyplot as plt
import tycc
import valcc
import geo
import MakeA as lib
import time


def makensolve(mygeo,  mytycc, myvalcc):
    vertices = (0,  mygeo.Nx-1,  mygeo.Nx*(geo.Ny-1),  mygeo.Nx*geo.Ny-1)
#  borde de abajo
    kc = np.linspace(vertices[0],  vertices[1], mygeo.Nx).astype(int)
# borde de arriba
    kd = np.linspace(vertices[2],  vertices[3], mygeo.Nx).astype(int)
# borde de la izquierda
    ka = np.linspace(vertices[0],  vertices[2], mygeo.Ny).astype(int)
# borde de la derecha
    kb = np.linspace(vertices[1],  vertices[3], mygeo.Ny).astype(int)
#  Solucion
    A, B = lib.makeA(ka, kb, kc, kd, mygeo, tycc, valcc)
    to = time.time()
    T = np.linalg.solve(A, B)
    dt = time.time()-to

    return T, dt


def main():
    T, dt = makensolve(geo, tycc, valcc)
    Tmat = np.zeros([geo.Nx, geo.Ny])

    for i in np.linspace(0, geo.Nx-1, geo.Nx).astype(int):
        for j in np.linspace(0, geo.Ny-1, geo.Ny).astype(int):
            k = i+j*geo.Nx
            Tmat[j, i] = T[k]

#  solo para graficar
    x = np.linspace(0, geo.Lx, geo.Nx).astype(float)
    y = np.linspace(0, geo.Ly, geo.Ny).astype(float)
    X, Y = np.meshgrid(x, y)

    CS = plt.contourf(X, Y, Tmat)
    CS2 = plt.contour(CS, levels=CS.levels, colors='k', linewidth=5)
    plt.xlabel('X')
    plt.ylabel('Y')
    cbar = plt.colorbar(CS, ticks=np.linspace(min(T), max(T), 10), boundaries=[min(T), max(T)])
    cbar.ax.set_ylabel('Temperature')

    plt.show()
    plt.savefig('Temperaturas-'+tycc.abajo+'.pdf')
# plt.show()
# plt.savefig('Temperaturas.pdf','pdf')

    np.savetxt('Temps-'+tycc.abajo+'.dat', T)
    np.savetxt('Temp_mat-'+tycc.abajo+'.dat', Tmat)


#  Ahora tengo que calcular los flujos.
#  dTx,  dTy =  gradient(Tmat)
    dTy,  dTx = lib.migrad(Tmat)
# print(dTx, dTy)
#  VX, VY  =  meshgrid(which_plot_x, which_plot_y)
    plt.streamplot(X, Y, -dTx, -dTy, color='k', linewidth=3, density=1)

    plt.show()
    plt.savefig('Temperaturas-'+tycc.abajo+'-Flujos.pdf')


if __name__ == "__main__":
    main()
