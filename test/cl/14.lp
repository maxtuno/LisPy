;; CL-14: loop with collect
(defun loop-collect-demo ()
  (let ((squares (loop for i from 1 to 6 collect (* i i)))
        (evens (loop for i from 1 to 12 when (evenp i) collect i))
        (pairs (loop for i from 1 to 5 collect (list i (* i i)))))
    
    (format t "Squares (1-6): ~A~%" squares)
    (format t "Even (1-12):  ~A~%" evens)
    (format t "Pairs (i, i^2): ~A~%" pairs)))

(loop-collect-demo)
