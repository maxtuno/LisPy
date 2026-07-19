(defun tarifa (edad)
  (cond ((< edad 5) 0) ((< edad 18) 5.0) ((< edad 65) 10.0) (t 7.5)))
(tarifa 30) (tarifa 70)
