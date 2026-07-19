;; ============================================================
;; QA-BUGFIX-04: Preprocessor escaping (BUG-A06) + Hybrid tests
;; Run: bin/lispy.exe < tests/qa_bugfix_04_escape.lp
;; ============================================================

;; Test: Python strings with special characters survive preprocessing
;; Previously: backslash and quote escaping was broken

(defvar *test-backslash* "back\\slash")
(defvar *test-quote* "he said \"hello\"")
(defvar *test-newline* "line1\nline2")

py_result_1 = builtins.lispy_callback_c("*test-backslash*")
py_result_2 = builtins.lispy_callback_c("*test-quote*")
py_result_3 = builtins.lispy_callback_c("*test-newline*")

(assert (equal "back\\slash" (py:->lisp @py_result_1)))
(assert (equal "he said \"hello\"" (py:->lisp @py_result_2)))
(assert (equal "line1\nline2" (py:->lisp @py_result_3)))

;; Test: Python f-strings with braces survive preprocessing
name = "world"
greeting = f"hello {name}"

(assert (equal "hello world" (py:->lisp @greeting)))

(print "BUG-A06: PASSED - preprocessing escaping correct")
