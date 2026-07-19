;; Test 14: Python code with indented blocks and conditional flow mixing with Lisp

(defun gt (a b)
  (> a b))

(defun add (a b)
  (+ a b))

values = []
for i in range(10):
    if gt(i, 5):
        values.append(i)
    else:
        values.append(add(i, 100))

acc = 0
for v in values:
    acc = add(acc, v)

(assert (= 645 (py:->lisp @acc)))

(print "Test 14 (indented Python with flow): OK")
