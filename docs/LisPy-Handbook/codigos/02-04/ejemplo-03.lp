(defmethod mostrar ((p punto))
  (with-slots (x y) p (format t "Punto(~D, ~D)~%" x y)))
