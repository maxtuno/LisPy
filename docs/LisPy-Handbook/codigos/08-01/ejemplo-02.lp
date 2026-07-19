(py:run "
M11 = m1*l1**2 + m2*(l1**2 + l2**2 + 2*l1*l2*sp.cos(t2))
M12 = m2*(l2**2 + l1*l2*sp.cos(t2))
M = sp.Matrix([[M11, M12], [M12, m2*l2**2]])")
