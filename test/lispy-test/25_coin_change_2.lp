(defun coin-change-2 (amount coins)
  (if (or (= amount 0) (null coins))
      (if (= amount 0) 1 0)
      (let ((dp (py:->python (make-array (1+ amount) :initial-element 0))))
        (py:call (py:attr dp "__setitem__") 0 1)
        (dolist (coin coins)
          (loop for i from coin to amount
                do (py:call (py:attr dp "__setitem__") i
                            (+ (py:getitem dp i)
                               (py:getitem dp (- i coin))))))
        (py:getitem dp amount))))

(format t "Coin Change 2:~%")
(format t "  amount=5 coins=[1,2,5] => ~A~%" (coin-change-2 5 '(1 2 5)))
(format t "  amount=3 coins=[2] => ~A~%" (coin-change-2 3 '(2)))
(format t "  amount=10 coins=[10] => ~A~%" (coin-change-2 10 '(10)))
