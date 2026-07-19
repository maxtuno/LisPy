(defun factorial (n) (if (<= n 1) 1 (* n (factorial (- n 1)))))
(defun factorial-tail (n)
  (labels ((iter (acc m) (if (<= m 1) acc (iter (* acc m) (- m 1)))))
    (iter 1 n)))
