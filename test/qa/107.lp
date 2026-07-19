(defun add (a b) (+ a b))
(defun sub (a b) (- a b))
(defun mul (a b) (* a b))
(defun div (a b) (/ a b))

a = add(10, 20)
b = sub(a, 5)
c = mul(b, 3)
d = div(c, 5)

(print @d)

x = div(add(100, mul(2, sub(50, div(80, 4)))), 5)

(print @x)

x = mul(add(1, add(2, add(3, 4))), sub(20, 10))

(print @x)

x = mul(div(add(1, 2), sub(4, 1)), 3)

(print @x)
