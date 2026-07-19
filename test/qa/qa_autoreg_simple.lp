;; Test: auto-registration of non-recursive function in hybrid mode

(defun square (x)
  (* x x))

results = []
for i in range(1, 6):
    results.append(square(i))

(print (py:->lisp @results))
