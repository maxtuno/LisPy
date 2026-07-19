;; Test 15: Multiple @var references in the same Python expression

(defvar *a* 10)
(defvar *b* 20)
(defvar *c* 30)

total = builtins.lispy_callback_c("*a*") + builtins.lispy_callback_c("*b*") + builtins.lispy_callback_c("*c*")

(assert (= 60 (py:->lisp @total)))

(print "Test 15 (multiple @var in one expr): OK")
