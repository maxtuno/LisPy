;; Test: defun auto-register makes function available in Python code
;; Simulates interactive REPL: define function, then use in Python

(print "-- executing qa_18 --")

(defun triple (x)
  (* 3 x))

(defun half (x)
  (/ x 2))

;; These Python lines use triple() and half() which were just defined above
a = triple(10)
b = half(a)

;; Verify values are correct via Lisp
(assert (= 30 @a))
(assert (= 15 @b))

;; Multiple defuns, all should be auto-registered
(defun add2 (x) (+ x 2))
(defun mul2 (x) (* x 2))

c = add2(5)
d = mul2(c)

(assert (= 7 @c))
(assert (= 14 @d))

(print "qa_18: OK")
