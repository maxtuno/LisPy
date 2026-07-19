(py:run "
import numpy as np, ctypes
arr = np.array([1.0, 2.0, 3.0])
ptr = arr.ctypes.data_as(ctypes.POINTER(ctypes.c_double))
")
