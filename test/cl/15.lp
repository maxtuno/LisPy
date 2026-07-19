;; CL-15: dotimes and dolist
(defun dotimes-dolist-demo ()
  (format t "dotimes (0 to 4):~%")
  (dotimes (i 5)
    (format t "  Iteration ~D, square = ~D~%" i (* i i)))
  
  (format t "~%dolist over (10 20 30):~%")
  (dolist (x '(10 20 30))
    (format t "  Value: ~D, half: ~D~%" x (/ x 2))))

(dotimes-dolist-demo)
