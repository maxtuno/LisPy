;; CL-40: Backquote and comma
(defun backquote-demo ()
  (let ((x 10)
        (y 20)
        (nums '(3 7 2)))
    (format t "Backquote with comma:~%")
    (format t "  `(a b c)      => ~A~%" `(a b c))
    (format t "  `(,x ,y)      => ~A~%" `(,x ,y))
    (format t "  `(x = ,x)     => ~A~%" `(x = ,x))
    (format t "  `(+ ,x ,y)    => ~A~%" `(+ ,x ,y))
    
    (format t "~%Splice with ,@:~%")
    (format t "  `(start ,@nums end) => ~A~%" `(start ,@nums end))
    
    (format t "~%Nested backquote:~%")
    (format t "  `(outer ,(list 'inner x)) => ~A~%" 
            `(outer ,(list 'inner x)))))

(backquote-demo)
