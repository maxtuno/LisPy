(defgeneric tasa-impuesto (pais))
(defmethod tasa-impuesto ((pais (eql :us))) 0.15)
(defmethod tasa-impuesto ((pais (eql :uk))) 0.20)
(defmethod tasa-impuesto (pais) 0.25)
