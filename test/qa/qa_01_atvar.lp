;; QA-01: Comprehensive @var tests

;; --- @var in Python expressions ---

x = 42
(assert (= 42 (py:->lisp @x)))
(print "QA-01a: simple @var OK")

;; --- @var in arithmetic ---
y = 10
z = @x + @y
(assert (= 52 (py:->lisp @z)))
(print "QA-01b: multiple @var in expr OK")

;; --- @var in Python list ---
arr = [@x, @y, @z]
(assert (equal '(42 10 52) (py:->lisp @arr)))
(print "QA-01c: @var in list OK")

;; --- @var in Python dict ---
d = {"a": @x, "b": @y}
(print (py:->lisp @d))

;; --- @var with Lisp reader fallback ---
(print @x)

;; --- Lisp @ reader with star-var ---
(defvar *test-val* 999)
(print @*test-val*)

(print "QA-01: ALL @VAR TESTS DONE")
