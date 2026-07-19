;; CL-35: eq, eql, equal, =
(defun equality-demo ()
  (format t "Numeric equality (=):~%")
  (format t "  (= 5 5)   => ~A~%" (= 5 5))
  (format t "  (= 5 5.0) => ~A~%" (= 5 5.0))
  (format t "  (= 5 6)   => ~A~%" (= 5 6))
  
  (format t "~%eq (identity):~%")
  (let* ((a '(1 2 3)) (b a) (c '(1 2 3)))
    (format t "  (eq a b) => ~A~%" (eq a b))
    (format t "  (eq a c) => ~A~%" (eq a c)))
  
  (format t "~%equal (structural):~%")
  (format t "  (equal '(a b) '(a b)) => ~A~%" (equal '(a b) '(a b)))
  (format t "  (equal '(a b) '(a c)) => ~A~%" (equal '(a b) '(a c)))
  (format t "  (equal \"abc\" \"abc\")  => ~A~%" (equal "abc" "abc")))

(equality-demo)
