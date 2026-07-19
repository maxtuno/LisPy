(defun leer-csv (archivo)
  (with-open-file (s archivo :direction :input)
    (loop for line = (read-line s nil nil) while line collect
          (uiop:split-string line :separator ","))))
