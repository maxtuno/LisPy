;; QA: Test recursive Lisp function called from Python

(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

x = factorial(5)

(print (py:->lisp @x))

(assert (= 120 (py:->lisp @x)))

(print "QA recursive: OK")
