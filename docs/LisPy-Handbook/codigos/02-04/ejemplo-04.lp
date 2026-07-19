(defgeneric area (figura))
(defmethod area ((p punto)) 0)
(defmethod area ((c circulo)) (* pi (expt (circulo-radio c) 2)))
