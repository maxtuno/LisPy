;; QA-13: Stress tests for the preprocessor block splitter
;; Tests complex multi-line patterns, indentation, and block boundaries

;; --- T1: Python block with deeply indented code ---
(defun add (a b) (+ a b))

values = []
for i in range(5):
    if i % 2 == 0:
        values.append(add(i, 100))
    else:
        values.append(add(i, 200))

(assert (equal '(100 201 102 203 104) (py:->lisp @values)))
(print "QA-13a: indented python block OK")

;; --- T2: Multiple consecutive Python blocks ---
x = 10
y = 20

z = add(x, y)

(assert (= 30 (py:->lisp @z)))
(print "QA-13b: consecutive python blocks OK")

;; --- T3: Lisp then Python then Lisp then Python in sequence ---
(defun double (x) (* 2 x))

a = double(7)

(defun triple (x) (* 3 x))

b = triple(7)
c = add(a, b)

(assert (= 35 (py:->lisp @c)))
(print "QA-13c: interleaved blocks OK")

;; --- T4: Python block with leading comment lines ---
;; This comment belongs to Lisp context
result_t4 = 99  # inline comment

(assert (= 99 (py:->lisp @result_t4)))
(print "QA-13d: comment in python block OK")

;; --- T5: Multiple Python blank-line separated blocks ---
a = 1

b = 2

c = add(a, b)

(assert (= 3 (py:->lisp @c)))
(print "QA-13e: blank-separated python blocks OK")

;; --- T6: defun spanning many lines ---
(defun complex-op (a b c d)
  (+ (* a b)
     (* c d)))

r_t6 = complex-op(2, 3, 4, 5)

(assert (= 26 (py:->lisp @r_t6)))
(print "QA-13f: multi-line defun OK")

(print "QA-13: ALL STRESS TESTS DONE")
