;; CL-23: find-if and position
(defun find-if-demo ()
  (let ((nums '(3 7 2 9 4 6 1 8 5))
        (names '("Alice" "Bob" "Charlie" "David")))
    (format t "Numbers: ~A~%" nums)
    (format t "First even: ~D~%" (find-if #'evenp nums))
    (format t "First > 5:  ~D~%" (find-if (lambda (x) (> x 5)) nums))
    (format t "Position of first even: ~D~%" (position-if #'evenp nums))
    (format t "~%Names: ~A~%" names)
    (format t "First long name (>4 chars): ~A~%" 
            (find-if (lambda (n) (> (length n) 4)) names))))

(find-if-demo)
