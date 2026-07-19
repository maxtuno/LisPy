(ignore-errors (py:run "1/0"))
(let ((frames (py:last-traceback)))
  (format t "El error tuvo ~D frames~%" (length frames)))
