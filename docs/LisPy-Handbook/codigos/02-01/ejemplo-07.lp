(defun make-acumulador ()
  (let ((total 0)) (lambda (n) (incf total n))))
