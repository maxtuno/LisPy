;; Test 3: @varname reading Lisp variables from Python blocks (requires Fase 1)

(defvar *my-value* 42)

val = builtins.lispy_callback_c("*my-value*")

(assert (= 42 (py:->lisp @val)))

(print "Test 3 (variable read via lispy_callback_c): OK")
