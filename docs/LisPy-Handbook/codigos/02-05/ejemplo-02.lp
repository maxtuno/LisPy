(defmethod procesar :around ((x integer))
  (format t "Around~%")
  (let ((r (call-next-method))) (* r 2)))
