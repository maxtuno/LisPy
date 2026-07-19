;; QA-10: Complex intricate hybrid syntax patterns
;; Tests deep nesting, mixed Lisp/Python in tight proximity, edge cases

;; --- Complex 1: Python closure capturing Lisp @var ---
(defvar *multiplier* 3)

def make_multiplier():
    m = builtins.lispy_callback_c("*multiplier*")
    return lambda x: x * m

triple = make_multiplier()
r1 = triple(7)

(assert (= 21 (py:->lisp @r1)))
(print "QA-10a: closure with @var OK")

;; --- Complex 2: Lisp function in Python list comprehension ---
(defun sq (x) (* x x))
(defun add (a b) (+ a b))

vals = [sq(i) for i in range(1, 6)]

(assert (equal '(1 4 9 16 25) (py:->lisp @vals)))
(print "QA-10b: fn in list comprehension OK")

;; --- Complex 3: Lisp @var in Python comprehensions ---
(defvar *offset* 10)
nums = [1, 2, 3, 4, 5]
shifted = [n + builtins.lispy_callback_c("*offset*") for n in nums]

(assert (equal '(11 12 13 14 15) (py:->lisp @shifted)))
(print "QA-10c: @var in comprehension OK")

;; --- Complex 4: Nested if/else with @var and Lisp calls ---
(defun gtp (a b) (> a b))
(defun ltp (a b) (< a b))
x = 42
y = 15
c = add(x, y) if ltp(x, y) else sq(x)

(assert (= 1764 (py:->lisp @c)))
(print "QA-10d: conditional ternary with fn OK")

;; --- Complex 5: Python try/except calling Lisp ---
(defun divide (a b) (/ a b))
r5 = None
try:
    r5 = divide(10, 2)
except Exception:
    r5 = -1

(assert (= 5 (py:->lisp @r5)))
(print "QA-10e: try/except with fn OK")

;; --- Complex 6: Lisp @var in Python string-building ---
(defvar *prefix* "ITEM-")
items_list = [builtins.lispy_callback_c("*prefix*") + str(i) for i in range(3)]

(assert (equal '("ITEM-0" "ITEM-1" "ITEM-2") (py:->lisp @items_list)))
(print "QA-10f: @var in string-building OK")

;; --- Complex 7: Deep Lisp call chain from Python ---
(defun inc (x) (+ x 1))
(defun dec (x) (- x 1))
(defun twice (x) (* x 2))
r7 = inc(twice(dec(10)))

(assert (= 19 (py:->lisp @r7)))
(print "QA-10g: deep fn chain OK")

;; --- Complex 8: Lisp functions with mixed case names ---
(defun MixCase (x) (* x x))
(defun MIXEDCase (x) (+ x x))
mc1 = MixCase(5)
mc2 = MIXEDCase(5)

(assert (= 25 (py:->lisp @mc1)))
(assert (= 10 (py:->lisp @mc2)))
(print "QA-10h: mixed-case fn names OK")

;; --- Complex 9: @var across multiple lines ---
(defvar *a* 10)
(defvar *b* 20)
(defvar *c* 30)

sum_abc = builtins.lispy_callback_c("*a*") + \
          builtins.lispy_callback_c("*b*") + \
          builtins.lispy_callback_c("*c*")

(assert (= 60 (py:->lisp @sum_abc)))
(print "QA-10i: multi-line @var acum OK")

;; --- Complex 10: Lisp recursive function in hybrid ---
(defun sum-to-n (n)
  (if (<= n 0)
      0
      (+ n (sum-to-n (- n 1)))))

r11 = sum-to-n(10)

(assert (= 55 (py:->lisp @r11)))
(print "QA-10k: recursive fn from Python OK")

;; --- Complex 11: Python class method calling Lisp ---
(defun times-ten (x) (* x 10))

class Calculator:
    def __init__(self, base):
        self.base = base
    def compute(self, x):
        return times-ten(self.base + x)

calc = Calculator(5)
r12 = calc.compute(3)

(assert (= 80 (py:->lisp @r12)))
(print "QA-10l: Python class + Lisp fn OK")

;; --- Complex 12: Python with-statement reading Lisp @var ---
(defvar *filename* "test.txt")
(defvar *content* "hello")

with_written = False
with open(builtins.lispy_callback_c("*filename*"), "w") as f:
    f.write(builtins.lispy_callback_c("*content*"))
    with_written = True

content_via_with = None
try:
    with open(builtins.lispy_callback_c("*filename*"), "r") as f:
        content_via_with = f.read()
except:
    content_via_with = "error"

(assert (equal "hello" (py:->lisp @content_via_with)))
(print "QA-10m: @var in with-statement OK")

(print "QA-10: ALL COMPLEX TESTS DONE")
