;; CL-52: map - general purpose mapping
(defun map-demo ()
  (let ((nums1 '(1 2 3 4))
        (nums2 '(10 20 30 40))
        (chars "hello"))
    
    (format t "map 'list with 2 lists:~%")
    (format t "  ~A + ~A = ~A~%" nums1 nums2 
            (map 'list #'+ nums1 nums2))
    (format t "  ~A * ~A = ~A~%" nums1 nums2
            (map 'list #'* nums1 nums2))
    
    (format t "~%map 'string:~%")
    (format t "  Uppercase: ~A~%" (map 'string #'char-upcase chars))
    
    (format t "~%map 'vector:~%")
    (format t "  Squares: ~A~%" (map 'vector (lambda (x) (* x x)) nums1))))

(map-demo)
