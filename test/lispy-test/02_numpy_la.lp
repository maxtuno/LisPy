;;; ============================================================
;;; LisPy Advanced 02 — NumPy: Linear Algebra
;;; Pure py: API — matrix ops, eigenvalues, SVD, solver
;;; ============================================================

(format t "~%=== LisPy + NumPy: Linear Algebra ===~%~%")

(let* ((np (py:import "numpy"))
       (la (py:attr np "linalg"))
       (array (py:attr np "array"))
       (bi (py:import "builtins")))

  (format t "[1] Matrix Operations~%")
  (let* ((a (py:call array (py:->python '((1.0 2.0 3.0) (4.0 5.0 6.0) (7.0 8.0 10.0)))))
         (b (py:call array (py:->python '((10.0 20.0 30.0) (40.0 50.0 60.0) (70.0 80.0 90.0)))))
         (at (py:attr a "T"))
         (det (py:call (py:attr bi "float") (py:call (py:attr la "det") a))))
    (format t "  A =~%~A~%" (py:str a))
    (format t "  A.T =~%~A~%" (py:str at))
    (format t "  det(A) = ~A~%~%" det))

  (format t "[2] Eigenvalues & Eigenvectors~%")
  (let* ((m (py:call array (py:->python '((4.0 -2.0) (1.0 1.0)))))
         (result (py:call (py:attr la "eig") m))
         (vals (first result))
         (vecs (second result)))
    (format t "  M = [[4,-2],[1,1]]~%")
    (format t "  eigenvalues = ~A~%" (py:str vals))
    (format t "  eigenvectors =~%~A~%~%" (py:str vecs)))

  (format t "[3] Solve Linear System Ax = b~%")
  (let* ((a (py:call array (py:->python '((3.0 2.0 -1.0) (2.0 -2.0 4.0) (-1.0 0.5 -1.0)))))
         (b (py:call array (py:->python '(1.0 -2.0 0.0))))
         (x (py:call (py:attr la "solve") a b)))
    (format t "  3x+2y-z=1, 2x-2y+4z=-2, -x+0.5y-z=0~%")
    (format t "  x = ~A~%~%" (py:str x)))

  (format t "[4] SVD Decomposition~%")
  (let* ((m (py:call array (py:->python '((1.0 2.0 3.0) (4.0 5.0 6.0)))))
         (result (py:call (py:attr la "svd") m))
         (s (second result)))
    (format t "  M = 2x3 matrix~%")
    (format t "  singular values = ~A~%~%" (py:str s)))

  (format t "[5] Least Squares~%")
  (let* ((x-data (py:call array (py:->python '(0.0 1.0 2.0 3.0 4.0 5.0))))
         (y-data (py:call array (py:->python '(1.1 3.8 8.9 16.2 24.9 36.1))))
         (n (py:len x-data))
         (a-mat (py:call array (py:->python `(,@(loop for xi from 0 below n collect (list 1 xi (expt xi 2)))))))
         (result (py:call (py:attr la "lstsq") a-mat y-data))
         (solution (first result)))
    (format t "  Fit y = c0 + c1*x + c2*x^2~%")
    (format t "  coefficients = ~A~%~%" (py:str solution)))

  (format t "=== Linear Algebra Demo Complete ===~%~%"))
