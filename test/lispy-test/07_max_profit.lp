;; Best Time to Buy and Sell Stock (LC #121) - Python max/min
(defun max-profit (prices)
  (if (null prices)
      0
      (let ((min-price (first prices))
            (max-prof 0))
        (dolist (p (rest prices))
          (setf min-price (py:min min-price p)
                max-prof (py:max max-prof (- p min-price))))
        max-prof)))

(print (max-profit '(7 1 5 3 6 4)))
(print (max-profit '(7 6 4 3 1)))
