;; CL-08: List operations - append, reverse, length
(defun list-operations ()
  (let ((list-a '(1 2 3))
        (list-b '(4 5 6)))
    (format t "List A: ~A~%" list-a)
    (format t "List B: ~A~%" list-b)
    (format t "Append: ~A~%" (append list-a list-b))
    (format t "Reverse A: ~A~%" (reverse list-a))
    (format t "Length A: ~D~%" (length list-a))
    (format t "nth 1 of A: ~D~%" (nth 1 list-a))
    (format t "last of A: ~A~%" (last list-a))))

(list-operations)
