;; CL-31: &rest parameters
(defun sum-all (&rest numbers)
  (format t "Summing ~A = " numbers)
  (reduce #'+ numbers))

(defun describe-args (label &rest args)
  (format t "~A: ~A~%" label args))

(format t "~D~%" (sum-all 1 2 3))
(format t "~D~%" (sum-all 10 20 30 40 50))
(describe-args "Extra arguments" 'alpha 'beta 'gamma)
