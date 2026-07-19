(load "lib/defpyclass.lp")
(defpyclass point ((x :initarg :x) (y :initarg :y)) :python-class-name "Point")
(defvar *p* (make-point :x 3 :y 4))
