(defvar *db*
  '((:producto-1 :nombre "Laptop" :precio 1200)
    (:producto-2 :nombre "Mouse"  :precio 25)))

(defun buscar-precio (id)
  (let ((entry (assoc id *db*)))
    (when entry
      (getf (cdr entry) :precio))))

(buscar-precio :producto-1)  ;; → 1200
