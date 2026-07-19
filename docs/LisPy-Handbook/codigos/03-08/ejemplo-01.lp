(defun test-pycall ()
  (let ((s (py:attr (py:import "math") "sqrt")))
    (time (dotimes (i 10000) (s (float i))))))
