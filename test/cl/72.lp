;; CL-72: the and check-type
(defun area-of-circle (radius)
  (check-type radius (real 0 *) "a positive real number")
  (* pi radius radius))

(defun safe-sqrt (x)
  (check-type x (real 0 *) "a non-negative real")
  (sqrt x))

(format t "Area r=5: ~F~%" (area-of-circle 5))
(format t "Area r=3.5: ~F~%" (area-of-circle 3.5))
(format t "sqrt of 25: ~F~%" (safe-sqrt 25))
