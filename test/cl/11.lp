;; CL-11: Recursion on lists - sum and length
(defun my-sum (lst)
  (if (null lst)
      0
      (+ (car lst) (my-sum (cdr lst)))))

(defun my-length (lst)
  (if (null lst)
      0
      (+ 1 (my-length (cdr lst)))))

(let ((nums '(3 7 2 9 1 4)))
  (format t "List: ~A~%" nums)
  (format t "Sum: ~D~%" (my-sum nums))
  (format t "Length: ~D~%" (my-length nums)))
