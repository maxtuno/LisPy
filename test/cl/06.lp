;; CL-06: when and unless conditionals
(defun grade-description (score)
  (let ((result ""))
    (when (>= score 90)
      (setq result (concatenate 'string result "Excellent ")))
    (when (and (>= score 70) (< score 90))
      (setq result (concatenate 'string result "Good ")))
    (unless (>= score 60)
      (setq result (concatenate 'string result "Needs Improvement")))
    result))

(format t "Score 95: ~A~%" (grade-description 95))
(format t "Score 75: ~A~%" (grade-description 75))
(format t "Score 50: ~A~%" (grade-description 50))
