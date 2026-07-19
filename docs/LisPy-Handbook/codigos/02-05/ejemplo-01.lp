(defgeneric procesar (x))
(defmethod procesar :before ((x numero)) (format t "Antes~%"))
(defmethod procesar :after ((x numero)) (format t "Después~%"))
(defmethod procesar ((x numero)) (* x x))
