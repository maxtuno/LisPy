;; CL-20: Property lists (plists)
(defun plist-demo ()
  (let ((person '(:name "Alice" :age 30 :city "New York")))
    (format t "Property list: ~A~%" person)
    (format t "Name: ~A~%" (getf person :name))
    (format t "Age: ~D~%" (getf person :age))
    (format t "City: ~A~%" (getf person :city))
    
    (setf (getf person :age) 31)
    (format t "Happy birthday! New age: ~D~%" (getf person :age))))

(plist-demo)
