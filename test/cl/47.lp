;; CL-47: destructuring-bind
(defun pair-operations ()
  (let ((pairs '((1 . 2) (3 . 4) (5 . 6))))
    (loop for pair in pairs do
      (destructuring-bind (a . b) pair
        (format t "Pair: ~D,~D  sum=~D  product=~D~%" a b (+ a b) (* a b))))))

(defun process-points ()
  (let ((points '((0 0) (3 4) (6 8))))
    (loop for (x y) in points do
      (format t "Point (~D,~D): distance from origin = ~F~%" x y
              (sqrt (+ (* x x) (* y y)))))))

(pair-operations)
(format t "~%")
(process-points)
