(defclass punto ()
  ((x :initarg :x :initform 0 :accessor punto-x)
   (y :initarg :y :initform 0 :accessor punto-y)))
(defclass punto-3d (punto) ((z :initarg :z :initform 0 :accessor punto-z)))
