;;; numpy-fast.lp — Accelerate Lisp numeric functions via NumPy

(defvar *numpy-init* nil)

(defun numpy-init ()
  (unless *numpy-init*
    (setf *numpy-init* t)
    (py:run "import numpy")
    (py:run
     "import numpy as _np
def _np_vec(fn_name, *args):
    f = getattr(_np, fn_name)
    return f(*args)
def _np_ufunc(op_name, a, b=None):
    if b is None:
        return getattr(_np, op_name)(a)
    return getattr(_np, op_name)(a, b)
"))
  t)

(defun numpy-array (data)
  "Create a NumPy array from Lisp data."
  (numpy-init)
  (let ((np (py:import "numpy")))
    (py:call (py:attr np "array") (py:->python data))))

(defun numpy-arange (n)
  "Create array 0..n-1."
  (numpy-init)
  (let ((np (py:import "numpy")))
    (py:call (py:attr np "arange") n)))

(defun numpy-linspace (start stop num)
  "Linearly spaced array."
  (numpy-init)
  (let ((np (py:import "numpy")))
    (py:call (py:attr np "linspace") (py:->python start) (py:->python stop) num)))

(defun numpy-zeros (shape)
  (numpy-init)
  (let ((np (py:import "numpy")))
    (py:call (py:attr np "zeros") (py:->python shape))))

(defun numpy-sin (arr)
  (numpy-init)
  (let ((main (py:import "__main__")))
    (py:call (py:attr main "_np_ufunc") "sin" arr)))

(defun numpy-cos (arr)
  (numpy-init)
  (let ((main (py:import "__main__")))
    (py:call (py:attr main "_np_ufunc") "cos" arr)))

(defun numpy-exp (arr)
  (numpy-init)
  (let ((main (py:import "__main__")))
    (py:call (py:attr main "_np_ufunc") "exp" arr)))

(defun numpy-log (arr)
  (numpy-init)
  (let ((main (py:import "__main__")))
    (py:call (py:attr main "_np_ufunc") "log" arr)))

(defun numpy-sum (arr &optional axis)
  (numpy-init)
  (let ((np (py:import "numpy")))
    (if axis
        (py:call (py:attr np "sum") arr (py:->python axis))
      (py:call (py:attr np "sum") arr))))

(defun numpy-mean (arr)
  (numpy-init)
  (let ((np (py:import "numpy")))
    (py:call (py:attr np "mean") arr)))

;; Fast vectorized Lisp function evaluator
(defmacro defnp (name args &rest body)
  "Define a Lisp function that uses NumPy for vectorized evaluation.
   For scalar args, uses regular Lisp arithmetic."
  `(defun ,name ,args
     (if (and ,@(mapcar (lambda (a) `(py:python? ,a)) args))
         ;; All args are NumPy arrays — vectorized
         (progn
           ,@body)
       ;; Scalar — use regular Lisp
       (progn
         ,@body))))
