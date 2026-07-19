(py:run "def acumulador():
    total = 0
    while True:
        val = yield total
        total += val")
(let* ((main (py:import "__main__")) (gen (py:call (py:attr main "acumulador"))))
  (py:gen-next gen)
  (py:gen-send gen 10)
  (py:gen-send gen 5))
