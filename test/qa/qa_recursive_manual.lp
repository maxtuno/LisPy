;; Manual registration of recursive function (using explicit py:run)

(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(py:register-callback 'factorial)

(py:run "
import builtins
result = builtins.factorial_cb(5)
")

(print (py:->lisp @result))

(assert (= 120 (py:->lisp @result)))

(print "Manual recursive test: OK")
