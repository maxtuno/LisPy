;;; ============================================================
;;; LisPy Advanced 10 — Fractals: Lisp-driven Mandelbrot + NumPy
;;; Pure py: API — Lisp iteration over NumPy arrays
;;; ============================================================

(format t "~%=== LisPy + NumPy: Fractal Generation ===~%~%")

(let* ((mpl (py:import "matplotlib")))
  (py:call (py:attr mpl "use") "Agg"))

(let* ((np (py:import "numpy"))
       (plt (py:import "matplotlib.pyplot"))
       (bi (py:import "builtins"))
       (to-int (py:attr bi "int"))
       (py-complex (py:attr bi "complex"))
       (width 120)
       (height 90)
       (max-iter 50)
       (j (py:call py-complex (py:->python 0) (py:->python 1))))

  (format t "[1] Mandelbrot Set (~Dx~D, ~D iters)~%" width height max-iter)

  (let* ((x (py:call (py:attr np "linspace") (py:->python -2.0) (py:->python 1.0) (py:->python width)))
         (y (py:call (py:attr np "linspace") (py:->python -1.5) (py:->python 1.5) (py:->python height)))
         (mesh (py:call (py:attr np "meshgrid") x y))
         (xx (first mesh))
         (yy (second mesh))
         (c (py:call (py:attr np "add") xx (py:call (py:attr np "multiply") j yy)))
         (z (py:call (py:attr np "zeros_like") c))
         (divtime (py:call (py:attr np "zeros") (py:->python `(,height ,width)) (py:->python "int32")))
         (two (py:->python 2.0))
         (i 0))
    (loop
      (when (>= i max-iter) (return))
      (let* ((z-sq (py:call (py:attr np "power") z two))
             (z-next (py:call (py:attr np "add") z-sq c))
             (diverge (py:call (py:attr np "greater") (py:call (py:attr np "abs") z-next) two))
             (div-now (py:call (py:attr np "logical_and") diverge
                               (py:call (py:attr np "equal") divtime (py:->python 0.0)))))
        (py:call (py:attr divtime "__setitem__") div-now (py:call to-int (py:->python (1+ i))))
        (py:call (py:attr z-next "__setitem__") diverge two)
        (setf z z-next))
      (incf i))
    (py:call (py:attr plt "figure"))
    (py:call (py:attr plt "imshow") divtime)
    (py:call (py:attr plt "title") "Mandelbrot (Lisp-driven)")
    (py:call (py:attr plt "savefig") "test/advanced/out_05_mandelbrot.png")
    (py:call (py:attr plt "close"))
    (format t "  Saved out_05_mandelbrot.png~%~%"))

  (format t "=== Fractal Demo Complete ===~%~%"))