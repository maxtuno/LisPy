(py:run "from scipy.interpolate import interp1d; import numpy as np
xs = np.array([0,1,2,3,4,5]); ys = np.array([0,0.8,0.9,0.1,-0.8,-1.0])
f = interp1d(xs, ys, kind='cubic'); xs_dense = np.linspace(0,5,100)")
