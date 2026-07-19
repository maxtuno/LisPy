(defvar *productos*
  '((:manzana . 0.50)
    (:pan . 2.00)
    (:leche . 1.20)))

(assoc :pan *productos*)   ;; → (:PAN . 2.00)
(rassoc 1.20 *productos*)  ;; → (:LECHE . 1.20)
