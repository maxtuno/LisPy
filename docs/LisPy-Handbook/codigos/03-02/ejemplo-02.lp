(let ((original '(a b c)))
  (equal original (py:->lisp (py:->python original))))
