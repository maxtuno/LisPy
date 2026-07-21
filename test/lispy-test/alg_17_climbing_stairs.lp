(defun climb-stairs (n)
  (if (<= n 2)
      n
      (let ((a 1) (b 2))
        (dotimes (i (- n 2))
          (let ((c (+ a b)))
            (setf a b b c)))
        b)))

(format t "Climbing Stairs:~%")
(format t "  n=2 => ~A~%" (climb-stairs 2))
(format t "  n=3 => ~A~%" (climb-stairs 3))
(format t "  n=5 => ~A~%" (climb-stairs 5))
