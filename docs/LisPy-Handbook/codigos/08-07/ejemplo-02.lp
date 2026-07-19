(defun calculate-discount (price customer-type)
  (case customer-type
    (:premium (* price 0.8))
    (:regular (* price 0.95))
    (otherwise price)))
