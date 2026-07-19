(defun descuento (p) (* p 0.9))
(py:register-callback 'descuento)
(py:run "from builtins import descuento_cb; print(descuento_cb(100))")
