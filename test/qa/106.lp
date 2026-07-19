(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

results = []
for i in range(1, 8):
    results.append(factorial(i))

(print (py:->lisp @results))

sum_results = 0
for r in results:
    sum_results += r

(print @sum_results)

n = factorial(10)

(assert (= 3628800 (py:->lisp @n)))

import math

python_fact_10 = math.factorial(10)

(assert (= 3628800 (py:->lisp @python_fact_10)))
