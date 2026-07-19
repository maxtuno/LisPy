;;; ============================================================
;;; LisPy Advanced 03 — NumPy: Statistics & Monte Carlo
;;; Pure py: API — descriptive stats, Monte Carlo Pi, distributions
;;; ============================================================

(format t "~%=== LisPy + NumPy: Statistics ===~%~%")

(let* ((np (py:import "numpy"))
       (array (py:attr np "array"))
       (bi (py:import "builtins"))
       (rng (py:call (py:attr (py:attr np "random") "default_rng") (py:->python 42)))
       (to-float (py:attr bi "float")))

  (format t "[1] Descriptive Statistics~%")
  (let* ((data (py:call array (py:->python '(23 27 19 31 25 28 33 22 26 29 30 24 27 35 21 28 32 26 25 29))))
         (m   (py:call to-float (py:call (py:attr np "mean") data)))
         (md  (py:call to-float (py:call (py:attr np "median") data)))
         (s   (py:call to-float (py:call (py:attr np "std") data)))
         (p25 (py:call to-float (py:call (py:attr np "percentile") data (py:->python 25))))
         (p75 (py:call to-float (py:call (py:attr np "percentile") data (py:->python 75)))))
    (format t "  20 points: mean=~A median=~A std=~A~%" m md s)
    (format t "  IQR [~A, ~A]~%~%" p25 p75))

  (format t "[2] Monte Carlo Pi Estimation~%")
  (let* ((n (py:->python 100000))
         (x (py:call (py:attr rng "random") n))
         (y (py:call (py:attr rng "random") n))
         (sq (py:call (py:attr np "add")
                      (py:call (py:attr np "power") x (py:->python 2.0))
                      (py:call (py:attr np "power") y (py:->python 2.0))))
         (inside (py:call to-float (py:call (py:attr np "sum") (py:call (py:attr np "less") sq (py:->python 1.0)))))
         (pi-est (/ (* 4.0 inside) 100000.0)))
    (format t "  100K darts, Pi: ~A (true: ~A)~%~%" pi-est (coerce pi 'float)))

  (format t "[3] Normal Distribution Sampling~%")
  (let* ((samples (py:call (py:attr rng "normal") (py:->python 0.0) (py:->python 1.0) (py:->python 1000)))
         (m (py:call to-float (py:call (py:attr np "mean") samples)))
         (s (py:call to-float (py:call (py:attr np "std") samples))))
    (format t "  N(0,1) x1000: mean=~A std=~A~%~%" m s))

  (format t "[4] Law of Large Numbers (Dice Rolls)~%")
  (let* ((rolls (py:call (py:attr rng "integers") (py:->python 1) (py:->python 7) (py:->python 50000)))
         (b-slice (py:attr bi "slice"))
         (k100  (py:call to-float (py:call (py:attr np "mean") (py:getitem rolls (py:call b-slice (py:->python 0) (py:->python 100))))))
         (k1k   (py:call to-float (py:call (py:attr np "mean") (py:getitem rolls (py:call b-slice (py:->python 0) (py:->python 1000))))))
         (k10k  (py:call to-float (py:call (py:attr np "mean") (py:getitem rolls (py:call b-slice (py:->python 0) (py:->python 10000))))))
         (kall  (py:call to-float (py:call (py:attr np "mean") rolls))))
    (format t "  n=  100: mean=~A~%" k100)
    (format t "  n= 1000: mean=~A~%" k1k)
    (format t "  n=10000: mean=~A~%" k10k)
    (format t "  n=50000: mean=~A (expected 3.5)~%~%" kall))

  (format t "=== Statistics Demo Complete ===~%~%"))
