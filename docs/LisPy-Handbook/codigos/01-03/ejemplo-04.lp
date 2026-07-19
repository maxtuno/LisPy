(push 'x lista)          ;; añade x al inicio
(pop lista)              ;; extrae y retorna el primer elemento
(pushnew 'x lista)       ;; añade si no existe
(append '(1 2) '(3 4))   ;; → (1 2 3 4)
(list* 1 2 '(3 4))       ;; → (1 2 3 4)
(make-list 5 :initial-element 0)  ;; → (0 0 0 0 0)
