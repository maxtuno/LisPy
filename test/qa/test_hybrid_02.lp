;; Test 2: Python blocks with loops and Lisp function calls

(defun multiply (a b)
  (* a b))

(defun add (a b)
  (+ a b))

m = 0
for i in range(10):
    m = add(m, multiply(i, i))

(assert (= 285 (py:->lisp @m)))

m = 0
for i in range(10):
    m = add(m, i)

(assert (= 45 (py:->lisp @m)))

(print "Test 2 (hybrid loops): OK")
