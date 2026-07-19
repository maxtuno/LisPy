;; CL-26: Fibonacci - multiple approaches
(defun fib-recursive (n)
  (if (< n 2)
      n
      (+ (fib-recursive (- n 1)) (fib-recursive (- n 2)))))

(defun fib-iterative (n)
  (do ((i 0 (+ i 1))
       (a 0 b)
       (b 1 (+ a b)))
      ((= i n) a)))

(format t "Fibonacci (recursive) first 10:~%")
(loop for i from 0 to 9 do
  (format t "  F(~D) = ~D~%" i (fib-recursive i)))

(format t "~%Fibonacci (iterative) F(20) = ~D~%" (fib-iterative 20))
