;; QA: Composed Lisp functions (non-recursive) called from Python

(defun square (x)
  (* x x))

(defun sum-of-squares (a b)
  (+ (square a) (square b)))

x = sum-of-squares(3, 4)

(print (py:->lisp @x))

(assert (= 25 (py:->lisp @x)))

(print "QA composed callback: OK")
