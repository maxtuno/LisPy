;; CL-32: apply and funcall
(defun apply-demo ()
  (let ((nums '(3 7 2 9 4)))
    (format t "List: ~A~%" nums)
    (format t "apply #'+:     ~D~%" (apply #'+ nums))
    (format t "apply #'max:   ~D~%" (apply #'max nums))
    (format t "apply #'list:  ~A~%" (apply #'list nums))
    
    (format t "~%funcall with lambda:~%")
    (format t "  funcall (lambda (x) (* x x)) 5 = ~D~%" 
            (funcall (lambda (x) (* x x)) 5))
    (format t "  funcall #'cons 'a '(b c) = ~A~%" 
            (funcall #'cons 'a '(b c)))))

(apply-demo)
