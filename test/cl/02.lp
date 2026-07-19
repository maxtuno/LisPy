;; CL-02: Basic arithmetic operations
(defun basic-arithmetic ()
  (format t "Addition:      10 + 5 = ~D~%" (+ 10 5))
  (format t "Subtraction:   10 - 5 = ~D~%" (- 10 5))
  (format t "Multiplication: 10 * 5 = ~D~%" (* 10 5))
  (format t "Division:      10 / 5 = ~D~%" (/ 10 5))
  (format t "Floor division: 10 / 3 = ~D~%" (floor 10 3))
  (format t "Modulus:       10 mod 3 = ~D~%" (mod 10 3))
  (format t "Exponent:      2 ^ 10 = ~D~%" (expt 2 10)))

(basic-arithmetic)
