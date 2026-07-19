import math
import random

(defun add (a b)
  (+ a b))

(defun multiply (a b)
  (* a b))

x = random.randint(0, 100)
y = random.randint(0, 100)

z = add(x, y)
w = multiply(x, y)

(print @z)
(print @w)

(defvar *name* "LisPy")
(defvar *version* 1)

info = f"{builtins.lispy_callback_c('*name*')} v{builtins.lispy_callback_c('*version*')}"

(print @info)
