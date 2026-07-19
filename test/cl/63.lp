;; CL-63: Tree traversal and manipulation
(defun tree-sum (tree)
  (cond ((null tree) 0)
        ((numberp tree) tree)
        ((consp tree) (+ (tree-sum (car tree)) (tree-sum (cdr tree))))
        (t 0)))

(defun flatten (tree)
  (cond ((null tree) nil)
        ((atom tree) (list tree))
        (t (append (flatten (car tree)) (flatten (cdr tree))))))

(let ((tree '((1 (2 3)) 4 (5 (6 7) 8) 9)))
  (format t "Tree: ~A~%" tree)
  (format t "Sum of all nodes: ~D~%" (tree-sum tree))
  (format t "Flattened: ~A~%" (flatten tree))
  (format t "Leaf count: ~D~%" (length (flatten tree))))
