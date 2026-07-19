(defun cuadrado (x) (* x x))
(define-compiler-macro cuadrado (x)
  (if (numberp x) `(* ,x ,x) `(cuadrado ,x)))
