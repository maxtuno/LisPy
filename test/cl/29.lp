;; CL-29: Optional parameters
(defun greet (&optional (name "World") (greeting "Hello"))
  (format t "~A, ~A!~%" greeting name))

(defun describe-point (x y &optional (label "Point"))
  (format t "~A: (~D, ~D)~%" label x y))

(greet)
(greet "Alice")
(greet "Bob" "Good morning")
(describe-point 3 5)
(describe-point 7 2 "Target")
