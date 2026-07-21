;;; ============================================================
;;; LisPy Advanced 09 — NumPy: FFT & Signal Processing
;;; Pure py: API — FFT frequency detection
;;; ============================================================

(format t "~%=== LisPy + NumPy: FFT & Signal Processing ===~%~%")

(let* ((np (py:import "numpy"))
       (fft (py:attr np "fft"))
       (bi (py:import "builtins"))
       (to-float (py:attr bi "float")))

  (format t "[1] FFT of Mixed Sinusoids~%")
  (let* ((n (py:->python 600))
         (dt (py:call (py:attr np "divide") (py:->python 1.0) (py:->python 800.0)))
         (x (py:call (py:attr np "linspace") (py:->python 0.0) (py:call (py:attr np "multiply") n dt) n nil))
         (y (py:call (py:attr np "add")
                     (py:call (py:attr np "sin") (py:call (py:attr np "multiply") (py:->python 314.159) x))
                     (py:call (py:attr np "multiply") (py:->python 0.5)
                              (py:call (py:attr np "sin") (py:call (py:attr np "multiply") (py:->python 753.982) x)))))
         (yf (py:call (py:attr fft "fft") y))
         (xf (py:call (py:attr fft "fftfreq") n dt))
         (abs-yf (py:call (py:attr np "abs") yf))
         (pos-mask (py:call (py:attr xf "__ge__") (py:->python 0.0)))
         (pos-freq (py:call (py:attr xf "__getitem__") pos-mask))
         (pos-amp (py:call (py:attr abs-yf "__getitem__") pos-mask))
         (peak-idx (py:call (py:attr np "argmax") pos-amp))
         (peak-freq (py:call (py:attr pos-freq "__getitem__") peak-idx)))
    (format t "  Signal: sin(50Hz) + 0.5*sin(120Hz)~%")
    (format t "  N=600, dt=1/800~%")
    (format t "  Strongest peak: ~A~%~%" (py:call to-float peak-freq)))

  (format t "[2] Inverse FFT Roundtrip~%")
  (let* ((n (py:->python 64))
         (x (py:call (py:attr np "arange") (py:->python 0.0) (py:call (py:attr np "divide") (py:call (py:attr np "multiply") (py:->python 2.0) (py:->python 3.14159)) n) (py:call (py:attr np "divide") (py:call (py:attr np "multiply") (py:->python 2.0) (py:->python 3.14159)) n)))
         (y (py:call (py:attr np "sin") x))
         (yf (py:call (py:attr fft "fft") y))
         (yr (py:call (py:attr np "real") (py:call (py:attr fft "ifft") yf)))
         (diff (py:call (py:attr np "max") (py:call (py:attr np "abs") (py:call (py:attr np "subtract") y yr)))))
    (format t "  sin(x) -> FFT -> IFFT -> sin(x)~%")
    (format t "  max reconstruction error: ~A~%~%" (py:call to-float diff))))

(format t "=== FFT Demo Complete ===~%~%")
