;; CL-77: Transpose a matrix
(defun matrix-transpose (matrix)
  (if (null (car matrix))
      nil
      (cons (mapcar #'car matrix)
            (matrix-transpose (mapcar #'cdr matrix)))))

(defun matrix-print (m name)
  (format t "~A:~%" name)
  (dolist (row m)
    (format t "  ")
    (dolist (val row)
      (format t "~4D" val))
    (format t "~%")))

(let ((original '((1 2 3)
                  (4 5 6)
                  (7 8 9))))
  (matrix-print original "Original")
  (matrix-print (matrix-transpose original) "Transposed"))
