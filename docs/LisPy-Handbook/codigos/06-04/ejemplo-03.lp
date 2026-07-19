(py:run "from scipy.optimize import root; import numpy as np
sol = root(lambda x: np.cos(x) - x, 0.5); print(sol.x)")
