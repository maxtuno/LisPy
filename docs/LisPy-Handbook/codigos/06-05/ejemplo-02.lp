(py:run "from scipy.integrate import solve_ivp; import numpy as np
def lv(t, z, a, b, d, g):
    x, y = z; return [a*x - b*x*y, d*x*y - g*y]
sol = solve_ivp(lv, [0,40], [10,5], args=(1.1,0.4,0.1,0.4),
                method='RK45', max_step=0.1)")
