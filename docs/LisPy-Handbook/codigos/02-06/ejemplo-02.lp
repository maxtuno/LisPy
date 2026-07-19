(handler-case (/ 1 0)
  (division-by-zero (c) (format t "Capturado: ~A~%" c) :infinito))
