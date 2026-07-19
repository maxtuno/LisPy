;; CL-27: Labels - local recursive functions
(defun labels-demo (n)
  (labels ((fact (x)
             (if (<= x 1) 1 (* x (fact (- x 1)))))
           (fib (x)
             (if (< x 2) x (+ (fib (- x 1)) (fib (- x 2))))))
    (format t "Using labels for local recursion:~%")
    (format t "  Factorial of ~D = ~D~%" n (fact n))
    (format t "  Fibonacci of ~D = ~D~%" n (fib n))))

(labels-demo 8)
