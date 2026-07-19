;; QA-11: Edge cases for hybrid syntax preprocessor
;; Tests that could expose parsing vulnerabilities

;; --- E1: defun on one line followed by python on next (tight proximity) ---
(defun add1 (x) (+ x 1))
a = add1(42)
(assert (= 43 (py:->lisp @a)))
(print "QA-11a: tight defun/python OK")

;; --- E2: @ signs inside Python comments ---
(defvar *v* 99)
# This is a comment with @*v* that should NOT expand
# Another comment line @fake_var
b = builtins.lispy_callback_c("*v*")  # But this @*v* is in comment on code line
(assert (= 99 (py:->lisp @b)))
(print "QA-11b: @ in comments OK")

;; --- E3: Multiple Lisp @var retrieved via lispy_callback_c ---
(defvar *a* 1)
(defvar *b* 2)
(defvar *c* 3)
result = builtins.lispy_callback_c("*a*") + builtins.lispy_callback_c("*b*") + builtins.lispy_callback_c("*c*")
(assert (= 6 (py:->lisp @result)))
(print "QA-11c: multi lisp-callback one line OK")

;; --- E4: Python print() using callback values ---
(defvar *secret* 777)
secret_val = builtins.lispy_callback_c("*secret*")
print(f"Secret is: {secret_val}")
(assert (= 777 (py:->lisp @secret_val)))
(print "QA-11d: print + callback OK")

;; --- E5: Lisp function with default parameter ---
(defun greet (&optional (name "World"))
  (concatenate 'string "Hello " name))

g1 = greet()
g2 = greet("LisPy")

(assert (equal "Hello World" (py:->lisp @g1)))
(assert (equal "Hello LisPy" (py:->lisp @g2)))
(print "QA-11e: optional-param fn OK")

;; --- E6: Python dict values from Lisp callbacks ---
x = 10
y = 20
d = {"a": x, "b": y, "c": x + y}
va = d["a"]
vc = d["c"]
(assert (= 10 (py:->lisp @va)))
(assert (= 30 (py:->lisp @vc)))
(print "QA-11f: dict with values OK")

;; --- E7: Zero-arg Lisp function from Python ---
(defun pi-value ()
  3.1415926535)

p = pi-value()

(assert (= 3.1415926535 (py:->lisp @p)))
(print "QA-11g: zero-arg fn OK")

;; --- E8: Python bool to Lisp boolean ---
x = 42
flag = x > 5
# flag is Python True, ->lisp converts to Lisp t
(print (py:->lisp @flag))
(print "QA-11h: bool comparison OK")

;; --- E9: Lisp function with hyphenated name ---
(defun add-two (a b) (+ a b))
r9 = add-two(100, 200)

(assert (= 300 (py:->lisp @r9)))
(print "QA-11i: hyphenated fn name OK")

;; --- E10: Lambda using Lisp function ---
(defun double (x) (* 2 x))
rv = (lambda a, b: double(a) + double(b))(3, 4)

(assert (= 14 (py:->lisp @rv)))
(print "QA-11j: lambda + fn OK")

(print "QA-11: ALL EDGE CASES DONE")
