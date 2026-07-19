;; CL-55: Function composition
(defun compose (f g)
  (lambda (&rest args)
    (funcall f (apply g args))))

(defun square (x) (* x x))
(defun add-one (x) (+ x 1))

(let ((square-after-add (compose #'square #'add-one))
      (add-after-square (compose #'add-one #'square)))
  (format t "Composition of square and add-one:~%")
  (format t "  square(add-one(5)) = ~D~%" (funcall square-after-add 5))
  (format t "  add-one(square(5)) = ~D~%" (funcall add-after-square 5))
  (format t "  (5+1)^2 = 36,  5^2+1 = 26~%"))
