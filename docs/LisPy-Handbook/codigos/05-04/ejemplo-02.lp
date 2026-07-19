(let ((extra '(z w)))
  (write-python-template `(def ,'func (x y ,@extra) "pass")))
