(load "lib/import-hooks.lp")
(py:register-ast-hook
  (lambda (module-name ast)
    (format t "Transformando: ~A~%" module-name) ast))
