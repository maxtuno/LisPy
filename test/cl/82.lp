;; CL-82: Simple generator pattern with closures
(defun make-range-generator (start end step)
  (let ((current (- start step)))
    (lambda ()
      (setf current (+ current step))
      (if (<= current end)
          current
          nil))))

(defun make-infinite-counter (start)
  (let ((n (- start 1)))
    (lambda ()
      (setf n (+ n 1))
      n)))

(let ((gen (make-range-generator 1 10 2)))
  (format t "Range generator (1 to 10, step 2):~%")
  (loop for val = (funcall gen)
        while val
        do (format t "  ~D~%" val)))

(let ((counter (make-infinite-counter 100)))
  (format t "~%First 5 from infinite counter starting at 100:~%")
  (dotimes (i 5)
    (format t "  ~D~%" (funcall counter))))
