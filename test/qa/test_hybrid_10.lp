;; Test 10: Nested Python call expressions with function composition and mixed @var

(defun add (a b)
  (+ a b))

(defun mult (a b)
  (* a b))

(defun square (x)
  (* x x))

(defun negate (x)
  (- x))

a = 3
b = 5
c = add(square(a), mult(a, b))
d = negate(c)
e = add(c, d)

(assert (= 0 (py:->lisp @e)))

(print "Test 10 (nested fn calls): OK")
