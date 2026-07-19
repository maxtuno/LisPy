;; CL-53: Coercion and type conversion
(defun coercion-demo ()
  (let ((num 123)
        (flt 3.14)
        (str "42")
        (lst '(a b c)))
    (format t "integer to string:   ~A~%" (write-to-string num))
    (format t "float to integer:    ~D~%" (floor flt))
    (format t "integer to float:    ~F~%" (float num))
    (format t "string to list:      ~A~%" (coerce str 'list))
    (format t "list to string:      ~A~%" (coerce lst 'string))
    (format t "list to vector:      ~A~%" (coerce '(1 2 3) 'vector))))

(coercion-demo)
