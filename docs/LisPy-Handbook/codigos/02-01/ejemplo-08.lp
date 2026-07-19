(defun divmod (a b) (values (floor a b) (mod a b)))
(multiple-value-bind (c r) (divmod 17 5) (list c r))
