(let ((it (py:iter (py:->python '(10 20 30)))))
  (loop for val = (py:next it) while val collect val))
