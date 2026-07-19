;; CL-58: nth value and multiple-value-list
(defun divide-with-remainder (a b)
  (values (floor a b) (mod a b)))

(let ((pairs '((17 5) (29 7) (42 8) (100 3))))
  (format t "~8A | ~8A | ~8A~%" "Division" "Quotient" "Remainder")
  (format t "--------------------------------~%")
  (loop for (a b) in pairs do
    (multiple-value-bind (q r) (divide-with-remainder a b)
      (format t "~D / ~D    | ~8D | ~8D~%" a b q r))))

(format t "~%Using multiple-value-list:~%")
(let ((results (multiple-value-list (divide-with-remainder 50 7))))
  (format t "  50/7 => ~A~%" results))
