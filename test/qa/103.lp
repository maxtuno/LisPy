import math
import random

m = 0
for i in range(10):
    m += random.randint(0, i)

(print @m)

(defun add (a b)
  (+ a b))

(defun multiply (a b)
  (* a b))

m = 0
for i in range(10):
    m = add(m, multiply(i, i))

(print @m)

m = 0
for i in range(10):
    m = add(m, i)

(print @m)

(defvar *pi* 3.1415926535)

print(f'Lisp *pi* = {@pi}')

(print @pi)
