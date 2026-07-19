;; CL-05: cond - multi-branch conditional
(defun describe-number (n)
  (cond ((< n 0) "negative")
        ((= n 0) "zero")
        ((> n 0) "positive")))

(format t "-5 is ~A~%" (describe-number -5))
(format t " 0 is ~A~%" (describe-number 0))
(format t " 7 is ~A~%" (describe-number 7))
