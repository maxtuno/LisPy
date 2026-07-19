(py:run "
import numpy as np
A = np.array([[1,2],[3,4]])
L, U = np.linalg.lu(A)
Q, R = np.linalg.qr(A)
U, S, Vt = np.linalg.svd(A)
eigvals, eigvecs = np.linalg.eig(A)")
