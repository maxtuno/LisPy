;; CL-16: do loop
(defun do-loop-demo ()
  (do ((i 1 (+ i 1))
       (sum 0 (+ sum i)))
      ((> i 10) sum)
    (format t "  i=~D, running sum=~D~%" i (+ sum i))))

(format t "Sum of 1-10 = ~D~%" (do-loop-demo))
