;; QA-06: Edge cases with comments, blank lines, and mixed syntax

; This is a Lisp comment
# This should be a Python comment (in Python blocks)

(defun add (a b) (+ a b))

;; --- Python comment with Lisp-like syntax ---
x = 10
# this is a comment with (parens) and @symbols
# another line
y = add(x, 20)

(assert (= 30 (py:->lisp @y)))
(print "QA-06a: Python comments OK")

;; --- Multiple Python blocks with persistent state ---
z = add(@x, @y)
(assert (= 40 (py:->lisp @z)))
(print "QA-06b: persistent state OK")

;; --- Empty line behavior ---
a = 1

b = 2

c = add(a, b)

(assert (= 3 (py:->lisp @c)))
(print "QA-06c: empty lines OK")

(print "QA-06: EDGE CASES DONE")
