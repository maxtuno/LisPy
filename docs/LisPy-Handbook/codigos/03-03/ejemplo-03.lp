(py:run "def f(n): return n * n")
(let ((main (py:import "__main__"))) (py:call (py:attr main "f") 5))
