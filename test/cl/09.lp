;; CL-09: Lambda functions
(defun lambda-demo ()
  (let ((square (lambda (x) (* x x)))
        (add-five (lambda (x) (+ x 5))))
    (format t "Square of 7: ~D~%" (funcall square 7))
    (format t "Add 5 to 10: ~D~%" (funcall add-five 10))
    (format t "Composed: ~D~%" (funcall square (funcall add-five 3)))))

(lambda-demo)
