;; QA-05: Python import and module integration

;; --- Python math module ---
import math

x1 = math.sqrt(64.0)
(assert (= 8.0 (py:->lisp @x1)))
(print "QA-05a: math.sqrt OK")

;; --- Lisp @ reader with Python module chain ---
(print @math:pi)

;; --- Lisp @ reader with nested attributes ---
(print @math:sqrt)

(print "QA-05: IMPORT TESTS DONE")
