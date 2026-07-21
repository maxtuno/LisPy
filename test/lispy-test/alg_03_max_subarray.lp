;; Maximum Subarray (LC #53) - Kadane with Python max
(defun max-subarray (nums)
  (let ((cur (first nums))
        (best (first nums)))
    (dolist (x (rest nums))
      (setf cur (py:max x (+ cur x))
            best (py:max best cur)))
    best))

(format t "Maximum Subarray:~%")
(format t "  [-2,1,-3,4,-1,2,1,-5,4] => ~A~%" (max-subarray '(-2 1 -3 4 -1 2 1 -5 4)))
