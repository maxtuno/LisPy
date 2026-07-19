(defmacro con-temp ((var valor) &body body)
  (let ((g (gensym)))
    `(let ((,g ,valor)) (let ((,var ,g)) ,@body))))
