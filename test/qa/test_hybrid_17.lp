;; Test 17: Python comment containing Lisp-like syntax (should not be parsed as Lisp)

# (defun fake-fn (x) (* x x))
# this is a python comment, NOT lisp

x = 42

(assert (= 42 (py:->lisp @x)))

(print "Test 17 (Python comments with (#): OK")
