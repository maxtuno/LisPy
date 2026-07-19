(defun flatten (lst)
  (if (null lst)
      nil
      (if (listp (car lst))
          (append (flatten (car lst))
                  (flatten (cdr lst)))
          (cons (car lst) (flatten (cdr lst))))))

(flatten '((1 2) (3 (4 5)) 6))  ;; → (1 2 3 4 5 6)
