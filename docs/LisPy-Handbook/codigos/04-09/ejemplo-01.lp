(py:run "def contador(n):
    for i in range(n): yield i * 2")
(let* ((main (py:import "__main__"))
       (gen (py:call (py:attr main "contador") 5)))
  (loop for val = (py:gen-next gen) while val collect val))
