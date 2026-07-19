;; Test 16: Lisp @var accessing Python var after import

import math

x = math.sqrt(64.0)

(assert (= 8.0 (py:->lisp @x)))

pi_val = math.pi

(assert (= 3.141592653589793 (py:->lisp @pi_val)))

(print "Test 16 (Python imports + Lisp @): OK")
