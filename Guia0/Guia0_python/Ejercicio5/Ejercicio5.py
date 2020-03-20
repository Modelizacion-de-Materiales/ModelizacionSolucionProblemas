# Ejecicio 5 
# resolver un sistema lineal
import numpy as np

A = np.array([[ 1, -3, -2],[2,-4,-3], [-3,6,8]])
b = np.array([[6],[8],[-5]])

X = np.linalg.solve(A,b)

print(X)


ERROR = np.matmul(A,X)- b

print(ERROR)

