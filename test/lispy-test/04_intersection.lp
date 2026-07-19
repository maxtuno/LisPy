;; Intersection of Two Arrays (LC #349) - Pure Lisp
(defun intersection (nums1 nums2)
  (let ((result nil))
    (dolist (x nums1)
      (when (and (member x nums2) (not (member x result)))
        (push x result)))
    (nreverse result)))

(format t "Intersection of Two Arrays:~%")
(format t "  [1,2,2,1] ∩ [2,2] => ~A~%" (intersection '(1 2 2 1) '(2 2)))
(format t "  [1,2] ∩ [3,4] => ~A~%" (intersection '(1 2) '(3 4)))
