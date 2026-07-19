;; CL-66: Concatenate and strings
(defun concatenate-demo ()
  (let ((words '("Common" "Lisp" "is" "fun"))
        (separator ", "))
    (format t "Concatenating strings:~%")
    (format t "  ~A~%" (concatenate 'string "Hello, " "world" "!"))
    (format t "  With separator: ~A~%" 
            (reduce (lambda (a b) (concatenate 'string a separator b)) words))
    (format t "~%Concatenating lists:~%")
    (format t "  ~A~%" (concatenate 'list '(1 2) '(3 4) '(5)))
    (format t "~%Concatenating vectors:~%")
    (format t "  ~A~%" (concatenate 'vector #(1 2) #(3 4) #(5)))))

(concatenate-demo)
