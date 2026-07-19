;; CL-33: Closures
(defun make-adder (n)
  (lambda (x) (+ x n)))

(defun make-counter ()
  (let ((count 0))
    (lambda ()
      (setq count (+ count 1))
      count)))

(let ((add5 (make-adder 5))
      (add10 (make-adder 10)))
  (format t "add5(3) = ~D~%" (funcall add5 3))
  (format t "add5(10) = ~D~%" (funcall add5 10))
  (format t "add10(3) = ~D~%" (funcall add10 3)))

(let ((counter (make-counter)))
  (format t "~%Counter: ~D, ~D, ~D~%" 
          (funcall counter) (funcall counter) (funcall counter)))
