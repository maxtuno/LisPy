(block busqueda
  (dotimes (i 10) (dotimes (j 10) (if (= i j 5) (return-from busqueda (list i j))))))
(catch 'found
  (dolist (x '(1 2 3 4 5)) (if (= x 3) (throw 'found :encontrado) (print x))))
