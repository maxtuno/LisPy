(defun primer-par-mayor-que (n lista)
  (loop named search for x in lista
        when (and (> x n) (evenp x)) do (return-from search x)))
