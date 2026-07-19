(defun safe-div (a b)
  (handler-case (values (/ a b) nil)
    (division-by-zero (c) (values 0 c))))
