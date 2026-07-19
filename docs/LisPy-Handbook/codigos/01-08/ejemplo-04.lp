(with-open-file (out "salida.txt" :direction :output :if-exists :supersede)
  (format out "Hola, archivo~%"))
(with-open-file (in "entrada.txt" :direction :input)
  (let ((c (read-line in nil nil))) c))
