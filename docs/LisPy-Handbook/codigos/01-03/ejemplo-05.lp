(member 3 '(1 2 3 4) :test #'=)       ;; → (3 4)
(find 'c '(a b c d) :test #'eq)       ;; → C
(position 3 '(1 2 3 4 5))              ;; → 2
