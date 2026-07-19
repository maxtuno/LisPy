;; QA-03: Python constructs in hybrid mode

;; --- Python def inside hybrid file ---
def py_square(x):
    return x * x

a = py_square(9)
(assert (= 81 (py:->lisp @a)))
(print "QA-03a: Python def OK")

;; --- Python class in hybrid file ---
class Counter:
    def __init__(self):
        self.n = 0
    def inc(self):
        self.n += 1
        return self.n

c = Counter()
r1 = c.inc()
r2 = c.inc()
r3 = c.inc()

(assert (= 3 (py:->lisp @r3)))
(print "QA-03b: Python class OK")

;; --- Python list comprehension ---
squares = [i*i for i in range(5)]
(assert (equal '(0 1 4 9 16) (py:->lisp @squares)))
(print "QA-03c: list comprehension OK")

;; --- Python if/else expression ---
v = 100
cond_result = @v * 2 if @v > 50 else @v
(assert (= 200 (py:->lisp @cond_result)))
(print "QA-03d: conditional OK")

(print "QA-03: ALL PYTHON CONSTRUCTS DONE")
