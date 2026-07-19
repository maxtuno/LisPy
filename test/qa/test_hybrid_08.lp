;; Test 8: Python blocks with internal empty lines (Bug: blank lines break blocks)
;; The preprocessor splits blocks on blank lines, breaking Python control flow.

(defun add (a b)
  (+ a b))

total = 0

for i in range(5):

    total = add(total, i)

(assert (= 10 (py:->lisp @total)))

(print "Test 8 (blank lines in Python): OK")
