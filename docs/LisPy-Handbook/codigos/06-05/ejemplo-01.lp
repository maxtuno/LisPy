(py:run "from scipy.integrate import solve_ivp; import numpy as np
def ode(t, y): return -2 * y
sol = solve_ivp(ode, [0,5], [1.0], method='RK45', t_eval=np.linspace(0,5,50))")
