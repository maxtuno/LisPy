(let* ((x (sympy-symbol "x")) (y (sympy-symbol "y"))
       (expr (sympy-expr '(+ (* (expt x 2) (expt y 3)) (* (sin x) (exp y))))))
  (sympy-derive expr x)
  (sympy-derive expr y))
