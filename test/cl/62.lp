;; CL-62: Merge sorted lists
(defun merge-lists (lst1 lst2 pred)
  (cond ((null lst1) lst2)
        ((null lst2) lst1)
        ((funcall pred (car lst1) (car lst2))
         (cons (car lst1) (merge-lists (cdr lst1) lst2 pred)))
        (t
         (cons (car lst2) (merge-lists lst1 (cdr lst2) pred)))))

(let ((a '(1 4 7 10))
      (b '(2 3 5 8 9)))
  (format t "List A: ~A~%" a)
  (format t "List B: ~A~%" b)
  (format t "Merged: ~A~%" (merge-lists a b #'<)))
