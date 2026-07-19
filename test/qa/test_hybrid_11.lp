;; Test 11: @var with only defvar (no defun) - tests Bug 1 (callback not registered)

(defvar *secret* 42)

result = builtins.lispy_callback_c("*secret*")

(assert (= 42 (py:->lisp @result)))

(print "Test 11 (callback with only defvar): OK")
