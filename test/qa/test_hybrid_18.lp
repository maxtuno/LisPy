;; Test 18: Python multi-line expression using backslash continuation

(defun add (a b)
  (+ a b))

result = add(1, \
             2)

(assert (= 3 (py:->lisp @result)))

(print "Test 18 (Python line continuation): OK")
