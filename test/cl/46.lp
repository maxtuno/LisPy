;; CL-46: case - switch-like conditional
(defun day-type (day)
  (case day
    ((1 7) "Weekend")
    ((2 3 4 5 6) "Weekday")
    (otherwise "Invalid day")))

(defun arithmetic-op (op a b)
  (case op
    (+ (+ a b))
    (- (- a b))
    (* (* a b))
    (/ (/ a b))
    (otherwise (format nil "Unknown op: ~A" op))))

(loop for d from 1 to 8 do
  (format t "Day ~D: ~A~%" d (day-type d)))
(format t "~%5 + 3 = ~D~%" (arithmetic-op '+ 5 3))
(format t "5 * 3 = ~D~%" (arithmetic-op '* 5 3))
