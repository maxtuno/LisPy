(py:run "
import numpy as np
A = np.array([[1,2],[3,4]]); B = np.array([[5,6],[7,8]])
print(A @ B); print(np.linalg.inv(A)); print(np.linalg.det(A))")
