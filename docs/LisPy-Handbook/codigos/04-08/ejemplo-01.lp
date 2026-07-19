(load "lib/persist.lp")
(py:run "x = 42; import numpy; arr = numpy.array([1,2,3])")
(py:save-session "mi-sesion.txt")
