;; CL-65: do* - sequential iteration
(defun do-star-demo ()
  (do* ((i 1 (+ i 1))
        (j i (* j i))
        (results nil))
       ((> i 5) (reverse results))
    (push (list i j (sqrt j)) results)))

(let ((table (do-star-demo)))
  (format t "do* sequential iteration (i and j = i!):~%")
  (format t "~3A | ~6A | ~10A~%" "i" "j=i!" "sqrt(j)")
  (format t "---|--------|----------~%")
  (dolist (row table)
    (destructuring-bind (i j s) row
      (format t "~3D | ~6D | ~10,6F~%" i j s))))
