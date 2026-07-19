(defun safe-py-run (code)
  (check-type code string)
  (py:run code))
