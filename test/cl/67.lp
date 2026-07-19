;; CL-67: Print vs princ vs prin1
(defun print-variants-demo ()
  (let ((obj "Hello"))
    (format t "princ (human readable): ")
    (princ obj)
    (format t "~%")
    
    (format t "prin1 (readable): ")
    (prin1 obj)
    (format t "~%")
    
    (format t "print (newline + readable):~%")
    (print obj))
  
  (format t "~%With special chars:~%")
  (let ((s "Line1~%Line2\"quoted\""))
    (format t "  princ: ")
    (princ s)
    (format t "~%")
    (format t "  prin1: ")
    (prin1 s)
    (format t "~%")))

(print-variants-demo)
