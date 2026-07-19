(let ((code (write-python-template `(def ,'test (x) "return x ** 2"))))
  (format t "Python:~%~A~%" code) (py:run code))
