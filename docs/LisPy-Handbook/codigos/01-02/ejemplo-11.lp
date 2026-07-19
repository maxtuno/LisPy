;; Fibonacci(100)
(defun fib (n)
  (if (< n 2) n
    (+ (fib (- n 1)) (fib (- n 2)))))
;; Nota: usar versión iterativa para valores grandes
