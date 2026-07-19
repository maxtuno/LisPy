;; CL-37: incf, decf, push, pop
(defun destructive-ops-demo ()
  (let* ((count 10)
         (stack '(c b a)))
    (format t "Initial count: ~D~%" count)
    (incf count 5)
    (format t "After (incf count 5): ~D~%" count)
    (decf count 3)
    (format t "After (decf count 3): ~D~%" count)
    (incf count)
    (format t "After (incf count): ~D~%" count)
    
    (format t "~%Initial stack: ~A~%" stack)
    (push 'x stack)
    (format t "After (push 'x): ~A~%" stack)
    (format t "Pop returned: ~A~%" (pop stack))
    (format t "Stack after pop: ~A~%" stack)))

(destructive-ops-demo)
