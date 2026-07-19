(defun zip (a b)
  (if (or (null a) (null b))
      nil
      (cons (cons (car a) (car b))
            (zip (cdr a) (cdr b)))))

(zip '(1 2 3) '(a b c))  ;; → ((1 . A) (2 . B) (3 . C))
