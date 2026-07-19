;; QA-15: Devilish preprocessor state machine tests
;; Tests for f-string state leakage, complex quoting, and scanner edge cases

;; --- D1: f-string with no @ followed by regular @var (state leakage test) ---
(defvar *val* 999)
s1 = f"no at signs here"
v1 = builtins.lispy_callback_c("*val*")

(assert (= 999 (py:->lisp @v1)))
(print "QA-15a: f-string state cleanup OK")

;; --- D2: Multiple f-strings, one with @, one without ---
(defvar *a* 10)
s2 = f"value: {builtins.lispy_callback_c('*a*')}"
s3 = f"no at signs"
v2 = builtins.lispy_callback_c("*a*") + 5

(assert (= 15 (py:->lisp @v2)))
(print "QA-15b: multiple f-strings OK")

;; --- D3: Nested braces in f-string ---
d = {"k": 42}
s4 = f"nested: {d['k']}"
(assert (equal "nested: 42" (py:->lisp @s4)))
(print "QA-15c: nested fstring braces OK")

;; --- D4: @ inside escaped chars ---
s5 = "literal \\@ not expanded"
(assert (equal "literal \\@ not expanded" (py:->lisp @s5)))
(print "QA-15d: escaped @ OK")

;; --- D5: @var with preceding colon ---
(defvar *x* 88)
v5 = 0
for i in range(3):
    v5 = v5 + builtins.lispy_callback_c("*x*")

(assert (= 264 (py:->lisp @v5)))
(print "QA-15e: loop with @var OK")

;; --- D6: Triple-quoted f-string ---
(defvar *world* "LisPy")
s6 = f"""hello
{builtins.lispy_callback_c('*world*')}
world"""
(assert (equal "hello\nLisPy\nworld" (py:->lisp @s6)))
(print "QA-15f: triple-quoted fstring OK")

;; --- D7: @ in Python raw f-string (fr"...") ---
(defvar *path* "/home/user")
s7 = fr"path: {builtins.lispy_callback_c('*path*')}\n"
(assert (equal "path: /home/user\\n" (py:->lisp @s7)))
(print "QA-15g: raw fstring OK")

;; --- D8: Python backslash in string ---
s8 = "line1\\\nline2"
(assert (equal "line1\\\nline2" (py:->lisp @s8)))
(print "QA-15h: backslash in string OK")

;; --- D9: Mixed f-string with braces and no @ ---
s9 = f"just {{braces}} here"
(assert (equal "just {braces} here" (py:->lisp @s9)))
(print "QA-15i: fstring with literal braces OK")

;; --- D10: Python line continuation in f-string ---
(defvar *label* "TEST")
s10 = f"label = \
  {builtins.lispy_callback_c('*label*')}"

(assert (equal "label =   TEST" (py:->lisp @s10)))
(print "QA-15j: line continuation fstring OK")

(print "QA-15: ALL DEVILISH TESTS DONE")
