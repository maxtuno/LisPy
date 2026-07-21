;;; ============================================================
;;; LisPy Advanced 07 — Lisp Macros + Python Hybrid
;;; Pure py: API — macros, error handling, numpy ops
;;; ============================================================

(format t "~%=== LisPy Hybrid Power ===~%~%")

(format t "[1] Lisp Iteration driving NumPy~%")
(let* ((np (py:import "numpy"))
       (array (py:attr np "array"))
       (bi (py:import "builtins"))
       (to-float (py:attr bi "float"))
       (a (py:call array (py:->python '(1.0 2.0 3.0 4.0 5.0))))
       (b (py:call array (py:->python '(5.0 4.0 3.0 2.0 1.0)))))
  (format t "  sum([1,2,3,4,5]) = ~A~%" (py:call to-float (py:call (py:attr np "sum") a)))
  (format t "  dot(a,b) = ~A~%~%" (py:call to-float (py:call (py:attr np "dot") a b))))

(format t "[2] Lisp Error Handling + Python~%")
(let ((caught (ignore-errors (py:import "this_module_does_not_exist"))))
  (if caught
      (format t "  Unexpected success~%")
    (format t "  Python ImportError caught in Lisp!~%~%")))

(format t "[3] Transparent py: builtin access~%")
(format t "  Python abs(-42) = ~A~%" (py:abs (py:->python -42)))
(format t "  Python pow(2,10) = ~A~%" (py:pow (py:->python 2) (py:->python 10)))
(format t "  Python max(1,5,3) = ~A~%~%" (py:max (py:->python 1) (py:->python 5) (py:->python 3)))

(format t "=== Hybrid Demo Complete ===~%~%")
