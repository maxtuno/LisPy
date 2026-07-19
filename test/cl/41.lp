;; CL-41: Basic macro definition
(defmacro square-macro (x)
  `(* ,x ,x))

(defmacro when-positive (expr body)
  `(if (> ,expr 0) ,body))

(format t "square-macro of 7: ~D~%" (square-macro 7))
(format t "square-macro of (+ 2 3): ~D~%" (square-macro (+ 2 3)))

(when-positive 5
  (format t "5 is positive!~%"))
(when-positive -3
  (format t "This won't print~%"))
