;; CL-03: Variables and let bindings
(defun let-bindings-demo ()
  (let ((x 10)
        (y 20))
    (format t "x = ~D, y = ~D~%" x y)
    (format t "x + y = ~D~%" (+ x y))
    (format t "x * y = ~D~%" (* x y))
    (let ((z (+ x y)))
      (format t "z = x + y = ~D~%" z))))

(let-bindings-demo)
