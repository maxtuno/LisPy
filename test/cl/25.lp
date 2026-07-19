;; CL-25: Sorting
(defun sorting-demo ()
  (let ((nums '(5 2 8 1 9 3 7 4 6))
        (words '("banana" "apple" "date" "cherry" "elderberry")))
    (format t "Original:    ~A~%" nums)
    (format t "Sorted asc:  ~A~%" (sort (copy-list nums) #'<))
    (format t "Sorted desc: ~A~%" (sort (copy-list nums) #'>))
    (format t "~%Words: ~A~%" words)
    (format t "Sorted: ~A~%" (sort (copy-list words) #'string<))
    (format t "By length: ~A~%" 
            (sort (copy-list words) (lambda (a b) (< (length a) (length b)))))))

(sorting-demo)
