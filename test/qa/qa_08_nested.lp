;; QA-08: @var inside Python function definitions and lambdas

(defun add (a b) (+ a b))

;; --- @var inside Python def ---
x = 100
def compute_nested(y):
    return add(y, @x)

r = compute_nested(50)
(assert (= 150 (py:->lisp @r)))
(print "QA-08a: @var in Python def OK")

;; --- @var in lambda ---
z = lambda n: add(n, @x)
r2 = z(25)
(assert (= 125 (py:->lisp @r2)))
(print "QA-08b: @var in lambda OK")

;; --- Lisp functions used inside Python def ---
def py_accum(start, n):
    result = start
    for i in range(n):
        result = add(result, i)
    return result

r3 = py_accum(0, 10)
(assert (= 45 (py:->lisp @r3)))
(print "QA-08c: Lisp fn in Python def OK")

(print "QA-08: NESTED FUNCTIONS DONE")
