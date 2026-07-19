;; CL-71: let* - sequential bindings
(defun let-star-demo ()
  (let* ((x 10)
         (y (+ x 5))
         (z (* y 2))
         (result (+ x (* y z) (* z z))))
    (format t "x = ~D (initial value)~%" x)
    (format t "y = x + 5 = ~D~%" y)
    (format t "z = y * 2 = ~D~%" z)
    (format t "result = x + y*z + z^2 = ~D~%" result)))

(let-star-demo)
