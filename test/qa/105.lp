(defun sq (x) (* x x))
(defun cube (x) (* x x x))

total = 0
for i in range(1, 6):
    total += sq(i)

(print @total)

total = 0
for i in range(1, 4):
    total += cube(i)

(print @total)

(defvar *pi* 3.14159265358979)
(defvar *e* 2.71828182845905)

pi_plus_e = builtins.lispy_callback_c("*pi*") + builtins.lispy_callback_c("*e*")

(print @pi_plus_e)

print(f'{@pi_plus_e}')
