(defclass point ()
  ((x :initarg :x :accessor point-x)
   (y :initarg :y :accessor point-y))
  (:metaclass python-sync-class))
