;; CL-75: the values special form
(defun min-max-avg (numbers)
  (let ((min-val (apply #'min numbers))
        (max-val (apply #'max numbers))
        (avg (/ (apply #'+ numbers) (length numbers))))
    (values min-val max-val (float avg))))

(defun describe-numbers (nums)
  (multiple-value-bind (min max avg) (min-max-avg nums)
    (format t "Dataset: ~A~%" nums)
    (format t "  Min: ~D~%" min)
    (format t "  Max: ~D~%" max)
    (format t "  Avg: ~,2F~%" avg)))

(describe-numbers '(7 2 9 4 5 8 3 6 1))
(format t "~%")
(describe-numbers '(15 22 8 19 31 12 44 28))
