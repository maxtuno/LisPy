(defclass a () ((val :initform "A")))
(defclass b () ((val :initform "B")))
(defclass c (a b) ())
