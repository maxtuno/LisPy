(defun add (a b) (+ a b))
(defun sub (a b) (- a b))
(defun eq (a b) (= a b))

fib_vals = [0, 1]
for i in range(2, 20):
    fib_vals.append(add(fib_vals[i - 1], fib_vals[i - 2]))

(print (py:->lisp @fib_vals))

def py_fib(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, add(a, b)
    return a

r = py_fib(20)

(assert (= 6765 (py:->lisp @r)))

s = 0
for i in range(10):
    s = add(s, py_fib(i))

(print @s)
