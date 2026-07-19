;; CL-88: Polynomial evaluation (Horner's method)
(defun horner-eval (coefficients x)
  "Evaluate polynomial with given coefficients at x using Horner's method"
  (reduce (lambda (acc coef) (+ (* acc x) coef))
          coefficients))

;; Polynomial: 3x^3 + 2x^2 + x + 5
;; Coefficients from highest degree: (3 2 1 5)
(format t "Polynomial evaluation (Horner's method):~%")
(format t "  3x^3 + 2x^2 + x + 5~%")
(format t "  at x=0:  ~D~%" (horner-eval '(3 2 1 5) 0))
(format t "  at x=1:  ~D~%" (horner-eval '(3 2 1 5) 1))
(format t "  at x=2:  ~D~%" (horner-eval '(3 2 1 5) 2))
(format t "  at x=-1: ~D~%" (horner-eval '(3 2 1 5) -1))

;; x^4 - 4x^3 + 6x^2 - 4x + 1 = (x-1)^4
(format t "~%  x^4 - 4x^3 + 6x^2 - 4x + 1 = (x-1)^4~%")
(format t "  at x=1:  ~D~%" (horner-eval '(1 -4 6 -4 1) 1))
(format t "  at x=2:  ~D~%" (horner-eval '(1 -4 6 -4 1) 2))
(format t "  at x=3:  ~D~%" (horner-eval '(1 -4 6 -4 1) 3))
