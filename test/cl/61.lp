;; CL-61: Simple quicksort implementation
(defun partition (pivot lst)
  (let ((less '()) (greater '()))
    (dolist (item lst)
      (if (< item pivot)
          (push item less)
          (push item greater)))
    (values (reverse less) (reverse greater))))

(defun quicksort (lst)
  (if (or (null lst) (null (cdr lst)))
      lst
      (let ((pivot (car lst)))
        (multiple-value-bind (less greater) (partition pivot (cdr lst))
          (append (quicksort less)
                  (list pivot)
                  (quicksort greater))))))

(let* ((nums '(5 2 9 1 5 6 3 8 4 7))
       (sorted (quicksort (copy-list nums))))
  (format t "Original: ~A~%" nums)
  (format t "Sorted:   ~A~%" sorted)
  (format t "Original unchanged: ~A~%" nums))
