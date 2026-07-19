;; CL-43: block and return-from
(defun search-value (target lst)
  (block searching
    (dolist (item lst)
      (when (= item target)
        (return-from searching item)))
    :not-found))

(format t "Search 5 in (1 2 3 4 5 6): ~A~%" (search-value 5 '(1 2 3 4 5 6)))
(format t "Search 9 in (1 2 3 4 5 6): ~A~%" (search-value 9 '(1 2 3 4 5 6)))

(block outer
  (format t "Entering outer block~%")
  (block inner
    (format t "  Entering inner block~%")
    (return-from outer 'exited-from-outer))
  (format t "This never prints~%"))
