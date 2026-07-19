;; Test 1: Lisp functions called transparently from Python blocks
;; Equivalent to 102.lp but in hybrid syntax

(defun add (a b)
  (+ a b))

(defun square (x)
  (* x x))

result = add(10, 20)

(assert (= 30 (py:->lisp @result)))

x = square(7)

(assert (= 49 (py:->lisp @x)))

; This is handled by the Lisp assertion function
(print "Test 1 (hybrid fn call): OK")
