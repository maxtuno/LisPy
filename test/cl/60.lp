;; CL-60: unwind-protect
(defun with-cleanup-demo ()
  (let ((resource :acquired))
    (unwind-protect
      (progn
        (format t "Using resource: ~A~%" resource)
        (format t "Doing work...~%")
        (/ 10 2))
      (format t "Cleanup: releasing resource ~A~%" resource)
      (setf resource nil))))

(defun with-cleanup-error ()
  (let ((resource :acquired))
    (unwind-protect
      (progn
        (format t "Using resource: ~A~%" resource)
        (format t "About to error...~%")
        (error "Something went wrong!"))
      (format t "Cleanup: releasing resource ~A~%" resource)
      (setf resource nil))))

(format t "=== Normal execution ===~%")
(with-cleanup-demo)
(format t "~%=== Error execution ===~%")
(handler-case (with-cleanup-error)
  (error (e) (format t "Caught: ~A~%" e)))
