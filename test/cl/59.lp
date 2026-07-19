;; CL-59: Error handling with handler-case
(defun safe-divide (a b)
  (handler-case (/ a b)
    (division-by-zero () :division-by-zero)
    (error (e) (format nil "Error: ~A" e))))

(format t "10 / 2 = ~D~%" (safe-divide 10 2))
(format t "10 / 0 = ~A~%" (safe-divide 10 0))

(defun safe-car (lst)
  (handler-case (car lst)
    (type-error () :not-a-list)
    (error (e) (format nil "Error: ~A" e))))

(format t "~%car of (1 2 3) = ~D~%" (safe-car '(1 2 3)))
(format t "car of nil = ~A~%" (safe-car nil))
