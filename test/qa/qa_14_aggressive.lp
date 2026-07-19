;; QA-14: Aggressive edge cases and boundary tests
;; Tests for potential crash scenarios, buffer overflows, and obscure patterns

;; --- A1: Very long @var name ---
(defvar *abcdefghijklmnopqrstuvwxyz_long_var* 123456)
v = builtins.lispy_callback_c("*abcdefghijklmnopqrstuvwxyz_long_var*")
(assert (= 123456 (py:->lisp @v)))
(print "QA-14a: long var name OK")

;; --- A2: @var with special chars in name ---
(defvar *test-var?* 42)
tv = builtins.lispy_callback_c("*test-var?*")
(assert (= 42 (py:->lisp @tv)))
(print "QA-14b: special-char var name OK")

;; --- A3: Lisp defvar variable access ---
(defvar *never* 0)
(assert (= 0 *never*))
(print "QA-14c: Lisp defvar var OK")

;; --- A4: Python block with only comments ---
# This is a Python-style comment only
# No actual code here (empty block)
;; But there is a Lisp assertion after
(print "QA-14d: comment-only blocks OK")

;; --- A5: Lisp function called with Python None ---
(defun is-nil (x) (null x))
n1 = is-nil(None)
(assert @n1)
(print "QA-14e: None arg to Lisp fn OK")

;; --- A6: Nested Python def with default args ---
(defun add (a b) (+ a b))

def outer(a, b=add(1, 2)):
    return a + b

o1 = outer(10)
o2 = outer(10, 20)

(assert (= 13 (py:->lisp @o1)))
(assert (= 30 (py:->lisp @o2)))
(print "QA-14f: nested Python def defaults OK")

;; --- A7: Python while loop calling Lisp ---
(defun dec (x) (- x 1))
n = 10
count = 0
while n > 0:
    n = dec(n)
    count = count + 1

(assert (= 10 (py:->lisp @count)))
(print "QA-14g: while loop with fn OK")

;; --- A8: Python set comprehension and len ---
(defun double (x) (* 2 x))
unique = {double(i) for i in range(1, 4)}
unique_len = len(unique)

(assert (= 3 (py:->lisp @unique_len)))
(print "QA-14h: set comprehension OK")

;; --- A9: @var with string concat ---
(defvar *greek* "alphabeta")
g1 = builtins.lispy_callback_c("*greek*") + "gamma"
(assert (equal "alphabetagamma" (py:->lisp @g1)))
(print "QA-14i: string concat OK")

;; --- A10: Python generator expression ---
(defun sq (x) (* x x))
gen = (sq(i) for i in range(1, 4))
total_gen = sum(gen)

(assert (= 14 (py:->lisp @total_gen)))
(print "QA-14j: generator expression OK")

;; --- A11: Python tuple conversion ---
a = (1, 2, 3)
(assert (equal '(1 2 3) (py:->lisp @a)))
(print "QA-14k: tuple equality OK")

;; --- A12: Very deeply nested Python if ---
(defun positive (x) (> x 0))
xs = [1, -2, 3, -4, 5]
result = []
for x in xs:
    if positive(x):
        result.append(x)
    elif x > -10:
        result.append(0)
    else:
        result.append(-1)

(assert (equal '(1 0 3 0 5) (py:->lisp @result)))
(print "QA-14l: deeply nested if OK")

;; --- A13: Lisp function with multiple return values ---
(defun two-values ()
  (values 10 20))

r13a = two-values()
(assert (= 10 (py:->lisp @r13a)))
(print "QA-14m: multiple return values OK")

(print "QA-14: ALL AGGRESSIVE TESTS DONE")
