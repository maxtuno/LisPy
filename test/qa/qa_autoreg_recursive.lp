;; Test: auto-registration of recursive function in hybrid mode

(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

r = factorial(5)

(print (py:->lisp @r))

(print "QA auto-reg recursive: DONE")
