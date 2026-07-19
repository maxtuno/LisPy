;; CL-30: Keyword parameters
(defun create-person (&key (name "Unknown") (age 0) (city "Unspecified"))
  (format t "Person: ~A, age ~D, from ~A~%" name age city))

(defun rectangle-area (&key (width 1) (height 1))
  (* width height))

(create-person :name "Alice" :age 28 :city "Boston")
(create-person :name "Bob" :city "Denver")
(create-person)

(format t "~%Rectangle 5x3 area: ~D~%" (rectangle-area :width 5 :height 3))
(format t "Rectangle 7x1 area: ~D~%" (rectangle-area :width 7))
