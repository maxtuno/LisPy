(defpyclass punto ((x :initarg :x :accessor px) (y :initarg :y :accessor py))
  :python-class-name "Punto")
(defvar *p* (make-punto :x 10 :y 20))
(px *p*)                               ;; → 10 (Lisp)
(py:attr (py:instance *p*) "x")        ;; → 10 (Python)
(py:%set-attr (py:instance *p*) "x" 99)
(px *p*)                               ;; → 99
