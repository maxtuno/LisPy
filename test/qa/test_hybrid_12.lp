;; Test 12: Python variable with @ resolution in Lisp context (Lisp reader handles @)

import random

total = 0
for i in range(5):
    total += i

x = total

(assert (= 10 (py:->lisp @x)))

(print "Test 12 (Lisp @ reads Python var): OK")
