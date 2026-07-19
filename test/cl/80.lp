;; CL-80: assert and check
(defun divide-with-check (a b)
  (assert (not (zerop b)) (b) "Division by zero: ~D/~D" a b)
  (/ a b))

(defun nth-element (n list)
  (assert (and (integerp n) (>= n 0)) (n) "Index must be non-negative integer")
  (assert (< n (length list)) (n) "Index out of bounds: ~D, length: ~D" n (length list))
  (nth n list))

(format t "10/2 = ~D~%" (divide-with-check 10 2))
(format t "15/3 = ~D~%" (divide-with-check 15 3))
; (divide-with-check 10 0) ; would signal error

(let ((lst '(apple banana cherry date)))
  (format t "~%List: ~A~%" lst)
  (format t "Element at 0: ~A~%" (nth-element 0 lst))
  (format t "Element at 2: ~A~%" (nth-element 2 lst)))
