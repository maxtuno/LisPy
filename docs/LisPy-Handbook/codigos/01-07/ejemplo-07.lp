(defun mcd (a b) (do* ((x a y) (y b (mod x y))) ((= y 0) x)))
(mcd 48 18)
