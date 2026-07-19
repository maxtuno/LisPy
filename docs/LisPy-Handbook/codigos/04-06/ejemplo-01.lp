(load "lib/sympy-bridge.lp")
(defvar *x* (sympy-symbol "x"))
(defvar *expr* (sympy-expr '(+ (expt x 2) (* 3 x) 1)))
