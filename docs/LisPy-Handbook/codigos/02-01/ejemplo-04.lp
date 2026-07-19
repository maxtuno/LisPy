(flet ((doble (x) (* x 2)) (triple (x) (* x 3))) (+ (doble 5) (triple 5)))
(labels ((par? (n) (if (= n 0) t (impar? (1- n))))
         (impar? (n) (if (= n 0) nil (par? (1- n)))))
  (par? 4))
