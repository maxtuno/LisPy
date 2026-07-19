(py:run "from scipy.optimize import curve_fit; import numpy as np
def modelo(x, a, b, c): return a * np.exp(b * x) + c
xdata = np.linspace(0, 4, 50)
ydata = modelo(xdata, 2.5, -0.5, 1.0) + 0.2*np.random.randn(50)
params, cov = curve_fit(modelo, xdata, ydata)")
