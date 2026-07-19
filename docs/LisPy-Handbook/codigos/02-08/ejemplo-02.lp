(with-input-from-string (s "(+ 1 2)") (read s))
(with-output-to-string (s) (princ "Hola" s) (princ " Mundo" s))
