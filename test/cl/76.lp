;; CL-76: Memoization with hash tables
(defparameter *fib-cache* (make-hash-table))

(defun fib-memo (n)
  (or (gethash n *fib-cache*)
      (setf (gethash n *fib-cache*)
            (if (< n 2)
                n
                (+ (fib-memo (- n 1)) (fib-memo (- n 2)))))))

(format t "Memoized Fibonacci:~%")
(loop for i from 0 to 10 do
  (format t "  F(~2D) = ~D~%" i (fib-memo i)))
(format t "F(35) = ~D~%" (fib-memo 35))
(format t "F(40) = ~D~%" (fib-memo 40))
