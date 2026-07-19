(let ((math (py:import "math")))
  (format t "pi = ~F~%" (py:attr math "pi"))
  (format t "sqrt(16) = ~F~%" (py:call (py:attr math "sqrt") 16)))
