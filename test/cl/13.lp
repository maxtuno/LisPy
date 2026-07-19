;; CL-13: loop macro basics
(defun loop-demo ()
  (format t "Counting from 1 to 5:~%")
  (loop for i from 1 to 5 do
    (format t "  i = ~D~%" i))
  
  (format t "~%Looping over list:~%")
  (loop for item in '(apple banana cherry) do
    (format t "  Fruit: ~A~%" item)))

(loop-demo)
