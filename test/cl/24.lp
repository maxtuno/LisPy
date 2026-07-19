;; CL-24: every and some predicates
(defun every-some-demo ()
  (let ((nums1 '(2 4 6 8 10))
        (nums2 '(2 4 6 7 10))
        (nums3 '(1 3 5 7 9)))
    (format t "~A all even? ~A~%" nums1 (every #'evenp nums1))
    (format t "~A all even? ~A~%" nums2 (every #'evenp nums2))
    (format t "~A all odd?  ~A~%" nums3 (every #'oddp nums3))
    (format t "~A has even? ~A~%" nums3 (some #'evenp nums3))))

(every-some-demo)
