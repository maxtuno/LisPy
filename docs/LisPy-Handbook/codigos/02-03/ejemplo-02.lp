(defmacro suma-cuadrados (a b) `(+ (* ,a ,a) (* ,b ,b)))
(macroexpand-1 '(suma-cuadrados 3 4))
