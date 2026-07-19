(py:run "
import math
import random
")

(py:run "
m = 0
for i in range(10):
    m += random.randint(0, i)
")

(print (py:->lisp @m))

(py:run "
m = 0
for i in range(10):
    m += math.sin(i)
")

(print (py:->lisp @m))