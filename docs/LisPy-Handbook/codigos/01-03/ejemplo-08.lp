(defvar *pila* nil)
(push 10 *pila*)     ;; → (10)
(push 20 *pila*)     ;; → (20 10)
(pop *pila*)         ;; → 20, *pila* → (10)
(pop *pila*)         ;; → 10, *pila* → nil
