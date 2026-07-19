(defun make-contador (&optional (inicial 0))
  (let ((cuenta inicial)) (lambda () (incf cuenta))))
(defvar *c* (make-contador 10))
(funcall *c*)
