(defvar *p* (make-instance 'punto :x 3 :y 4))
(punto-x *p*)
(setf (punto-x *p*) 5)
(slot-value *p* 'y)
