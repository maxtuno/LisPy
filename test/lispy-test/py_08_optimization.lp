;;; ============================================================
;;; LisPy Advanced 08 — SciPy: Integration
;;; Pure py: API — numerical integration via py:call
;;; ============================================================

(format t "~%=== LisPy + SciPy: Integration ===~%~%")

(let* ((scipy (py:import "scipy"))
       (integrate (py:attr scipy "integrate"))
       (np (py:import "numpy"))
       (bi (py:import "builtins"))
       (to-float (py:attr bi "float"))
       (sin-fn (py:attr np "sin"))
       (sq-fn (py:attr np "square")))

  (format t "[1] int sin(x) dx [0..pi]~%")
  (let ((result (py:call (py:attr integrate "quad") sin-fn (py:->python 0.0) (py:->python 3.14159265))))
    (let ((val (first result)) (err (second result)))
      (format t "  value = ~A (exact: 2.0)~%" (py:call to-float val))
      (format t "  error = ~A~%~%" (py:call to-float err))))

  (format t "[2] int x^2 dx [0..1]~%")
  (let ((result (py:call (py:attr integrate "quad") sq-fn (py:->python 0.0) (py:->python 1.0))))
    (let ((val (first result)) (err (second result)))
      (format t "  value = ~A (exact: 0.3333)~%" (py:call to-float val))
      (format t "  error = ~A~%~%" (py:call to-float err)))))

(format t "=== SciPy Demo Complete ===~%~%")
