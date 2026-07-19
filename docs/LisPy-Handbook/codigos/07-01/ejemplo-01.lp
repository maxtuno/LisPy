(defun fib (n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
(compile 'fib)
(time (fib 30))
