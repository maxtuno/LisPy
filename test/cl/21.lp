;; CL-21: reduce - folding over lists
(defun reduce-demo ()
  (let ((nums '(1 2 3 4 5 6 7 8 9 10)))
    (format t "Numbers: ~A~%" nums)
    (format t "Sum (reduce #'+):     ~D~%" (reduce #'+ nums))
    (format t "Product (reduce #'*): ~D~%" (reduce #'* nums))
    (format t "Max (reduce #'max):   ~D~%" (reduce #'max nums))
    (format t "String concat: ~A~%" 
            (reduce (lambda (a b) (concatenate 'string a " " b))
                    '("the" "quick" "brown" "fox")))))

(reduce-demo)
