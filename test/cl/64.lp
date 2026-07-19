;; CL-64: loop with sum, count, maximize, minimize
(defun loop-aggregate-demo ()
  (let ((nums '(3 7 2 9 4 6 1 8 5))
        (words '("cat" "elephant" "dog" "hippopotamus" "fox")))
    
    (format t "Numbers: ~A~%" nums)
    (format t "  Sum:      ~D~%" (loop for n in nums sum n))
    (format t "  Count even: ~D~%" (loop for n in nums count (evenp n)))
    (format t "  Maximize: ~D~%" (loop for n in nums maximize n))
    (format t "  Minimize: ~D~%" (loop for n in nums minimize n))
    (format t "  Average:  ~F~%" (let ((s (loop for n in nums sum n))
                                        (c (length nums)))
                                    (float (/ s c))))
    
    (format t "~%Words: ~A~%" words)
    (format t "  Longest:  ~A~%" (car (sort (copy-list words) 
                                          (lambda (a b) (> (length a) (length b))))))
    (format t "  Shortest: ~A~%" (car (sort (copy-list words) 
                                           (lambda (a b) (< (length a) (length b))))))))

(loop-aggregate-demo)
