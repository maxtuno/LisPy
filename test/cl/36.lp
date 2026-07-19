;; CL-36: defparameter, defvar, setq, setf
(defparameter *global-counter* 0 "A global counter variable")
(defvar *default-name* "Untitled" "Default name for entities")

(defun increment-global ()
  (setq *global-counter* (+ *global-counter* 1))
  *global-counter*)

(format t "Initial counter: ~D~%" *global-counter*)
(format t "After inc: ~D~%" (increment-global))
(format t "After inc: ~D~%" (increment-global))

(let ((person (list :name "Bob" :age 25)))
  (format t "~%Before: ~A~%" person)
  (setf (getf person :age) 26)
  (format t "After (setf age): ~A~%" person)
  (setf (getf person :city) "Paris")
  (format t "After (setf city): ~A~%" person))
