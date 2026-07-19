;; Test 13: Python string with @ inside double-quoted string that is NOT a variable ref
;; The @ should be literal in the string, not resolved.

text = "not a @variable ref"

(assert (equal "not a @variable ref" (py:->lisp @text)))

(print "Test 13 (@ in double-quoted string): OK")
