(defun dot-product (a b)
  (reduce #'+ (map 'vector #'* a b)))
(dot-product #(1 2 3) #(4 5 6))
