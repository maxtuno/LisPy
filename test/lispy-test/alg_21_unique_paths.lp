(defun unique-paths (m n)
  (let ((grid (make-array (list m n) :initial-element 1)))
    (loop for i from 1 below m
          do (loop for j from 1 below n
                   do (setf (aref grid i j)
                            (+ (aref grid (1- i) j)
                               (aref grid i (1- j))))))
    (aref grid (1- m) (1- n))))

(format t "Unique Paths:~%")
(format t "  3x7 => ~A~%" (unique-paths 3 7))
(format t "  3x2 => ~A~%" (unique-paths 3 2))
