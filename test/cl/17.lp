;; CL-17: format function - number formatting
(defun format-numbers ()
  (format t "Decimal:      ~D~%" 12345)
  (format t "Hexadecimal:   ~X~%" 255)
  (format t "Octal:         ~O~%" 64)
  (format t "Binary:        ~B~%" 42)
  (format t "Fixed-float:   ~F~%" 3.14159)
  (format t "Scientific:    ~E~%" 3.14159)
  (format t "Dollars:       ~$~%" 45.678))

(format-numbers)
