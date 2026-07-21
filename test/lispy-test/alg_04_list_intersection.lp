;; List Intersection (LC #349) - Pure Lisp
(defun list-intersection (nums1 nums2)
  (let ((result nil))
    (dolist (x nums1)
      (when (and (member x nums2) (not (member x result)))
        (push x result)))
    (nreverse result)))

(format t "List Intersection:~%")
(format t "  [1,2,2,1] ∩ [2,2] => ~A~%" (list-intersection '(1 2 2 1) '(2 2)))
(format t "  [1,2] ∩ [3,4] => ~A~%" (list-intersection '(1 2) '(3 4)))
