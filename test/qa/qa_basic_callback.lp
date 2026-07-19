;; QA: Basic non-recursive Lisp function called from Python

(defun square (x)
  (* x x))

(defun cube (x)
  (* x x x))

a = square(7)
b = cube(3)

(print (py:->lisp @a))
(print (py:->lisp @b))

(assert (= 49 (py:->lisp @a)))
(assert (= 27 (py:->lisp @b)))

(print "QA basic callback: OK")
