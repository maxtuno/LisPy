;; CL-74: Input and output with read-line
(defun interactive-demo ()
  (format t "Simple I/O demonstration:~%")
  (format *query-io* "Enter your name: ")
  (force-output *query-io*)
  (let ((name (read-line *query-io*)))
    (format t "~%")
    (format t "Hello, ~A!~%" name)))

;(interactive-demo)  ; uncomment for interactive use

(format t "Testing with predefined inputs...~%")
