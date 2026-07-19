;; CL-38: Arrays
(defun array-demo ()
  (let ((arr (make-array '(3 3) :initial-element 0)))
    (format t "Initial 3x3 array:~%")
    (dotimes (i 3)
      (dotimes (j 3)
        (format t " ~D" (aref arr i j)))
      (format t "~%"))
    
    (setf (aref arr 0 0) 1)
    (setf (aref arr 1 1) 1)
    (setf (aref arr 2 2) 1)
    
    (format t "~%Identity matrix:~%")
    (dotimes (i 3)
      (dotimes (j 3)
        (format t " ~D" (aref arr i j)))
      (format t "~%"))
    
    (format t "Array dimensions: ~A~%" (array-dimensions arr))))

(array-demo)
