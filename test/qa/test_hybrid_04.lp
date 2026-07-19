;; Test 4: Pure Lisp file passes through unchanged

(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(assert (= 120 (factorial 5)))
(assert (= 3628800 (factorial 10)))

(print "Test 4 (pure Lisp pass-through): OK")
