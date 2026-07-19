(let ((kw (make-hash-table :test 'equal)))
  (setf (gethash "axis" kw) 0)
  (py:call-kw (py:attr (py:import "numpy") "sum") kw arr))
