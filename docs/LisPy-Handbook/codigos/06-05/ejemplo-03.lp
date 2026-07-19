(py:run "from scipy.integrate import quad; import numpy as np
result, error = quad(lambda x: x**2, 0, 1); print(result)")
