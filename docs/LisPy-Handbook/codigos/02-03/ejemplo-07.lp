(defmacro with-coords ((x y) point &body body)
  `(let ((,x (car ,point)) (,y (cadr ,point))) ,@body))
(with-coords (a b) '(10 20) (+ a b))
