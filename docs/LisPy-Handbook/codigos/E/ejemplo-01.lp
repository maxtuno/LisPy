(defgeneric fn-name (param1 param2 ...)
  (:documentation "doc")
  (:method (param1 param2 ...) body)
  (:method :around ((p1 class1) p2) body))
