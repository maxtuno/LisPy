(let* ((x (sympy-symbol "x"))
       (expr (sympy-expr '(* (sin x) (exp (expt x 2))))))
  (sympy-derive expr x))
