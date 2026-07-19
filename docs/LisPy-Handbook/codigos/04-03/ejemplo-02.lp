(let ((alpha 0.01))
  (defpyfun leaky-relu (x) "return x if x > 0 else alpha * x" :as lrelu-py))
(lrelu-py -2)
