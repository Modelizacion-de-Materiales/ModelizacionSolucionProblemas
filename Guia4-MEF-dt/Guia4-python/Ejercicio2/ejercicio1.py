import numpy as np
import matplotlib.pyplot as plt
from barrat import barra
import pdb

B = barra()
B.mesh(4)

dt = 0.1
r = np.linspace(1, B.T.shape[0]-1, B.T.shape[0]-1, dtype=int)
s = [0]

#    T(r,i)=T(r,i-1)-C(r,r)\( dt*( K(r,r)*T(r,i-1)+K(r,s)*T(s,i-1) ) );
#     fs(:,i-1)=C(s,:)*partialT(:,i-1)+K(s,:)*T(:,i-1);

T = [B.T]
F = [-B.conductivity.prod()*np.gradient(B.T, axis=0)]
t = 0
tmax = 5000
dT = [np.zeros_like(B.T)]
while t <= tmax:
    t += dt
    T.append(
            np.vstack((
                T[-1][s],
                T[-1][r] - dt*np.linalg.solve(
                    B.C[np.ix_(r, r)],
                    B.K[np.ix_(r, r)].dot(T[-1][r]) + B.K[np.ix_(r, s)].dot(T[-1][s])
                    )
                ))
            )
    dT.append((T[-1] - T[-2])/dt)
    F.append(
            B.C.dot(dT[-1])+B.K.dot(T[-1])
            )
T = np.array(T).reshape(len(T), T[-1].shape[0])
F = np.array(F).reshape(len(F), F[-1].shape[0])
