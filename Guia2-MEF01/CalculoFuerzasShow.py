def NI(x, l):
    return 1. - x/l

def ND(x, l):
    return x/l

def Tx(x):
    return -C*x

def dfI(x, a, l):
    return NI(x-a, l) * Tx(x)

def dfD(x, a, l):
    return ND(x-a, l)*Tx(x)

def dfI(x, a, l):
    return NI(x-a, l) * Tx(x)

def dfD(x, a, l):
    return ND(x-a, l)*Tx(x)
