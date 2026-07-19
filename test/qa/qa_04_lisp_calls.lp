;; QA-04: Lisp function call edge cases

;; --- Multiple Lisp function calls in one Python line ---
(defun add (a b) (+ a b))
(defun mul (a b) (* a b))

r1 = add(mul(2, 3), mul(4, 5))
(assert (= 26 (py:->lisp @r1)))
(print "QA-04a: nested Lisp calls OK")

;; --- Lisp function with Python variable and literal ---
x = 10
r2 = add(x, add(20, 30))
(assert (= 60 (py:->lisp @r2)))
(print "QA-04b: mixed args OK")

;; --- Lisp function returning value used in Python expression ---
r3 = mul(add(1, 2), add(3, 4))
(assert (= 21 (py:->lisp @r3)))
(print "QA-04c: expression composition OK")

;; --- Lisp function with conditional ---
(defun max2 (a b)
  (if (> a b) a b))

r4 = max2(100, 200)
(assert (= 200 (py:->lisp @r4)))
(print "QA-04d: Lisp conditional from Python OK")

(print "QA-04: ALL LISP CALL TESTS DONE")
