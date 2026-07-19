(py:register-ast-hook
  (lambda (module-name ast)
    (walk-ast ast
      (lambda (node)
        (when (and (listp node) (eq (car node) 'FunctionDef))
          (format t "  → ~A~%" (cadr node)))))
    ast))
