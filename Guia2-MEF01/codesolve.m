    r = [2, 3]
    s = [1, 4]
    U = zeros(4,1)
    F = zeros(4,1)
    U(s) = [0, 0.002]
    F(R) = [0, 0]
    U(r) = K(r,r)\(F(r) - K(r, s)*U(s))
