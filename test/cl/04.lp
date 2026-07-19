;; CL-04: Recursive factorial function
(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(format t "Factorial of 0:  ~D~%" (factorial 0))
(format t "Factorial of 1:  ~D~%" (factorial 1))
(format t "Factorial of 5:  ~D~%" (factorial 5))
(format t "Factorial of 10: ~D~%" (factorial 10))
