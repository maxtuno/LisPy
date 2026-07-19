(let* ((ctypes (py:import "ctypes"))
       (libc (py:call (py:attr ctypes "CDLL") "msvcrt.dll")))
  (py:call (py:attr libc "printf") (py:->python "Número: %d\\n") 42))
