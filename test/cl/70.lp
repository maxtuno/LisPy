;; CL-70: Basic set operations
(defun set-ops-demo ()
  (let ((a '(1 2 3 4 5))
        (b '(3 4 5 6 7)))
    (format t "Set A: ~A~%" a)
    (format t "Set B: ~A~%" b)
    
    (format t "~%Union:        ~A~%" (union a b))
    (format t "Intersection:  ~A~%" (intersection a b))
    (format t "Difference A-B: ~A~%" (set-difference a b))
    (format t "Difference B-A: ~A~%" (set-difference b a))
    (format t "Symmetric diff: ~A~%" 
            (set-exclusive-or a b))
    (format t "~%Is A subset of (1..10)? ~A~%" 
            (subsetp a '(1 2 3 4 5 6 7 8 9 10)))
    (format t "Is (3 5) subset of A? ~A~%" 
            (subsetp '(3 5) a))))

(set-ops-demo)
