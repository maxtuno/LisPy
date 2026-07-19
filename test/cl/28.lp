;; CL-28: labels - local recursive/mutual-reference functions
(defun labels-demo (x y)
  (labels ((square (n) (* n n))
           (average (a b) (/ (+ a b) 2))
           (hypotenuse (a b) (sqrt (+ (square a) (square b)))))
    (format t "x = ~D, y = ~D~%" x y)
    (format t "Square of x: ~D~%" (square x))
    (format t "Average: ~D~%" (average x y))
    (format t "Hypotenuse: ~F~%" (hypotenuse x y))))

(labels-demo 3 4)
