(handler-bind ((warning #'(lambda (c) (format t "Advertencia~%") (muffle-warning c))))
  (warn "Alerta"))
