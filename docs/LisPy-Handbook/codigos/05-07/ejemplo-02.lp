(defvar *numpy-init* nil)
(defun numpy-array (data)
  (unless *numpy-init* (setf *numpy-init* t) (py:import "numpy"))
  ...)
