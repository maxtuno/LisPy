(let* ((x (sympy-symbol "x"))
       (expr (sympy-expr '(+ (expt x 3) (* 2 (expt x 2)) (* 5 x) 7))))
  (sympy-derive expr x))
