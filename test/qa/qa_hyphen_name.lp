;; QA: Lisp function with hyphen in name called from Python

(defun add-two (a b)
  (+ a b))

x = add-two(10, 20)

(print (py:->lisp @x))

(assert (= 30 (py:->lisp @x)))

(print "QA hyphen name: OK")
