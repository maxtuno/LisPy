;; CL-10: mapcar - mapping over lists
(defun mapcar-demo ()
  (let ((nums '(1 2 3 4 5))
        (fruits '("apple" "banana" "cherry" "date" "elderberry")))
    (format t "Numbers: ~A~%" nums)
    (format t "Squares: ~A~%" (mapcar (lambda (x) (* x x)) nums))
    (format t "Doubled: ~A~%" (mapcar (lambda (x) (* 2 x)) nums))
    (format t "Uppercase: ~A~%" (mapcar #'string-upcase fruits))))

(mapcar-demo)
