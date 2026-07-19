(defun make-power-fn (name exp)
  (write-python-template
    `(def ,(intern name) (x) "return x ** ,exp")))
(make-power-fn "cube" 3)
