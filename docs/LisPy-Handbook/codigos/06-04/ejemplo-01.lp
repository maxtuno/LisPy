(py:run "from scipy.optimize import minimize; import numpy as np
def rosenbrock(x): return (1-x[0])**2 + 100*(x[1]-x[0]**2)**2
result = minimize(rosenbrock, [0,0], method='BFGS')")
