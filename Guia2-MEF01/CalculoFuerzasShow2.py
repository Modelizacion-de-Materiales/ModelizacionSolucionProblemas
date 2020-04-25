def fuerza():
    """
    define las fuerzas equivalentes sobre los nodos para la
    distribucuón de fuerzas T(x) = - C*x
    """
    F = np.zeros((len(MN), 1))
    for i in range(len(MN)-1):
        a = MN[i, 0]
        b = MN[i+1, 0]
        li = b - a
        F[i] += quad(lambda x: dfI(x, a, li), a, b)[0]
        F[i+1] += quad(lambda x: dfD(x, a, li), a, b)[0]
    return F

