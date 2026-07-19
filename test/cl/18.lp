;; CL-18: Strings and character operations
(defun string-demo ()
  (let ((s "Hello, Common Lisp!"))
    (format t "String: ~A~%" s)
    (format t "Length: ~D~%" (length s))
    (format t "Uppercase: ~A~%" (string-upcase s))
    (format t "Lowercase: ~A~%" (string-downcase s))
    (format t "Character at 0: ~C~%" (char s 0))
    (format t "Character at 7: ~C~%" (char s 7))
    (format t "Substring 0-5: ~A~%" (subseq s 0 5))))

(string-demo)
