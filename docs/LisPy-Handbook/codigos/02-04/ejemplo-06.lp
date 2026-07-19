(defclass shape () ((color :initarg :color :initform :black)))
(defclass circle (shape) ((radius :initarg :radius :initform 1)))
(defclass rectangle (shape) ((width :initarg :width :initform 1) (height :initarg :height :initform 1)))
