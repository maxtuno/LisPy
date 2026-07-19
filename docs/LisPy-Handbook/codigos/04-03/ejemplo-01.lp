(let ((factor 3.1416))
  (defpyfun scale (x) "return x * factor" :as scale-py))
(scale-py 10)
