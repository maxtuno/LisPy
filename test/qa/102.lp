;; reverse of 101.lp: usar cálculos Lisp desde Python con py:register-callback
;; py:register-callback expone funciones Lisp como builtins.<fn>_cb en Python.
;; Para leer una variable Lisp desde Python no hay mecanismo directo:
;; se necesita una función getter que la retorne.

(defun add (a b)
  (+ a b))

(defun multiply (a b)
  (* a b))

(py:register-callback 'add)
(py:register-callback 'multiply)

(py:run "
import builtins

m = 0
for i in range(10):
    m = builtins.add_cb(m, builtins.multiply_cb(i, i))
")

(print (py:->lisp @m))

(py:run "
import builtins

m = 0
for i in range(10):
    m = builtins.add_cb(m, i)
")

(print (py:->lisp @m))

;; — leer variables Lisp desde Python: se envuelven en funciones getter —

(defvar *pi* 3.1415926535)

(defun get-pi ()
  *pi*)

(py:register-callback 'get-pi)

(py:run "
import builtins
lisp_pi = builtins.get_pi_cb()
print(f'Lisp *pi* = {lisp_pi}')
")

(print (py:->lisp @lisp_pi))
