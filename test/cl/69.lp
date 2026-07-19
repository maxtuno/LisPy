;; CL-69: Parsing integers and numbers
(defun parse-demo ()
  (let ((tests '("42" "3.14" "1010" "FF" "-256" "  789  ")))
    (format t "parse-integer examples:~%")
    (dolist (s tests)
      (handler-case
        (let ((result (parse-integer s :junk-allowed t)))
          (format t "  \"~A\" => ~D~%" s result))
        (error (e) (format t "  \"~A\" => ERROR: ~A~%" s e))))
    
    (format t "~%Radix examples:~%")
    (format t "  \"1010\" base 2:  ~D~%" (parse-integer "1010" :radix 2))
    (format t "  \"FF\" base 16:   ~D~%" (parse-integer "FF" :radix 16))
    (format t "  \"77\" base 8:    ~D~%" (parse-integer "77" :radix 8))))

(parse-demo)
