;; Test 9: @ symbol inside Python string literals (Bug: regex matches inside strings)
;; The preprocessor should NOT replace @ inside string literals.

s = "this is just a string with an @ symbol in it"

(assert (equal "this is just a string with an @ symbol in it" (py:->lisp @s)))

(print "Test 9 (@ in Python strings): OK")
