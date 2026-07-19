;; CL-56: Binary search
(defun binary-search (target vec)
  (let ((low 0)
        (high (- (length vec) 1)))
    (loop while (<= low high) do
      (let* ((mid (floor (+ low high) 2))
             (mid-val (aref vec mid)))
        (cond ((= mid-val target) (return mid))
              ((< mid-val target) (setf low (+ mid 1)))
              (t (setf high (- mid 1))))))
    nil))

(let ((arr (coerce '(2 5 8 12 16 23 38 45 56 67 78 89) 'vector)))
  (format t "Array: ~A~%" arr)
  (format t "Search 23: index ~D~%" (binary-search 23 arr))
  (format t "Search 45: index ~D~%" (binary-search 45 arr))
  (format t "Search 50: ~A~%" (binary-search 50 arr))
  (format t "Search 2:  index ~D~%" (binary-search 2 arr))
  (format t "Search 89: index ~D~%" (binary-search 89 arr)))
