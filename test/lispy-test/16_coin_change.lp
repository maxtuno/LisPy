(defun coin-change (coins amount)
  (if (= amount 0)
      0
      (let ((dp (py:->python (make-array (1+ amount) :initial-element (1+ amount)))))
        (py:call (py:attr dp "__setitem__") 0 0)
        (dolist (coin coins)
          (loop for i from coin to amount
                do (py:call (py:attr dp "__setitem__") i
                            (py:min (py:getitem dp i)
                                    (1+ (py:getitem dp (- i coin)))))))
        (let ((result (py:getitem dp amount)))
          (if (> result amount) -1 result)))))

(format t "Coin Change:~%")
(format t "  coins=[1,2,5] amount=11 => ~A~%" (coin-change '(1 2 5) 11))
(format t "  coins=[2] amount=3 => ~A~%" (coin-change '(2) 3))
(format t "  coins=[1] amount=0 => ~A~%" (coin-change '(1) 0))
