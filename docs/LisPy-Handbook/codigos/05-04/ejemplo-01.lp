(let ((func-name "fast_pow") (exponent 10))
  (write-python-template
    `(def ,(intern func-name) (x) "return x ** ,exponent")))
