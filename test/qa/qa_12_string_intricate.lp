;; QA-12: String and f-string intricate tests
;; Tests tricky combinations of quotes, @, braces, and string types

;; --- S1: @ inside raw strings ---
s1 = r"raw with @ sign"
(assert (equal "raw with @ sign" (py:->lisp @s1)))
(print "QA-12a: @ in raw string OK")

;; --- S2: @ inside byte string ---
s2 = b"bytes with @"
;; NOTE: @s2.decode() is not supported by the @ reader (method calls
;; must use py:call+py:attr). Changed to use py:call + py:attr.
(assert (equal "bytes with @" (py:->lisp (py:call (py:attr @s2 "decode")))))
(print "QA-12b: @ in bytes string OK")

;; --- S3: f-string with {} braces and @var inside expression ---
(defvar *user* "Kilo")
(defvar *age* 1)

msg3 = f"{builtins.lispy_callback_c('*user*')} is version {builtins.lispy_callback_c('*age*')}"

(assert (equal "Kilo is version 1" (py:->lisp @msg3)))
(print "QA-12c: f-string with expr and @var OK")

;; --- S4: f-string with nested braces ---
d = {"name": "test"}
msg4 = f"value: {d['name']}"
(assert (equal "value: test" (py:->lisp @msg4)))
(print "QA-12d: f-string nested braces OK")

;; --- S5: Multi-line f-string ---
(defvar *name* "LisPy")
msg5 = f"""Multi-line
string with
{builtins.lispy_callback_c('*name*')} inside"""

(assert (equal "Multi-line\nstring with\nLisPy inside" (py:->lisp @msg5)))
(print "QA-12e: multi-line f-string OK")

;; --- S6: Python string format with @var ---
name = builtins.lispy_callback_c("*name*")
msg6 = "System: {}".format(name)

(assert (equal "System: LisPy" (py:->lisp @msg6)))
(print "QA-12f: str.format + @var OK")

;; --- S7: String with escape sequences containing @ ---
s7 = "path\\to\\@file"
(assert (equal "path\\to\\@file" (py:->lisp @s7)))
(print "QA-12g: escaped path with @ OK")

;; --- S8: @var in concatenated strings ---
a8 = "a"
b8 = "b"
s8 = @a8 + "-" + @b8
(assert (equal "a-b" (py:->lisp @s8)))
(print "QA-12h: @var string concat OK")

(print "QA-12: ALL STRING INTRICATE TESTS DONE")
