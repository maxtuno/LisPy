(with-open-file (stream "datos.txt" :direction :output :if-exists :supersede)
  (format stream "línea 1~%"))
