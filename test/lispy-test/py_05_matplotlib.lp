;;; ============================================================
;;; LisPy Advanced 05 — Matplotlib Plotting
;;; ============================================================

(format t "~%=== LisPy + Matplotlib ===~%~%")

(let ((mpl (py:import "matplotlib")))
  (py:call (py:attr mpl "use") "Agg"))

(let* ((plt (py:import "matplotlib.pyplot"))
       (np (py:import "numpy")))

  (format t "[1] Sine + Cosine~%")
  (let* ((x (py:call (py:attr np "linspace") (py:->python 0.0) (py:->python 12.56) (py:->python 200)))
         (y1 (py:call (py:attr np "sin") x))
         (y2 (py:call (py:attr np "cos") x)))
    (py:call (py:attr plt "figure"))
    (py:call (py:attr plt "plot") x y1 "b-" x y2 "r--")
    (py:call (py:attr plt "title") "Trigonometric Functions")
    (py:call (py:attr plt "savefig") "test/advanced/out_01_sine_cosine.png")
    (py:call (py:attr plt "close"))
    (format t "  Saved out_01_sine_cosine.png~%"))

  (format t "~%[2] Histogram~%")
  (let* ((samples (py:call (py:attr (py:attr np "random") "standard_normal") (py:->python 500))))
    (py:call (py:attr plt "figure"))
    (py:call (py:attr plt "hist") samples (py:->python 30))
    (py:call (py:attr plt "title") "Normal Distribution")
    (py:call (py:attr plt "savefig") "test/advanced/out_02_histogram.png")
    (py:call (py:attr plt "close"))
    (format t "  Saved out_02_histogram.png~%"))

  (format t "~%=== Matplotlib Demo Complete ===~%~%"))
