(defun saludar (nombre &optional (saludo "Hola"))
  (format t "~A, ~A~%" saludo nombre))
(defun suma (&rest numeros) (reduce #'+ numeros))
(defun crear-punto (&key (x 0) (y 0)) (cons x y))
