;; Two Sum (LC #1) - Python dict via hash-table conversion
(defun two-sum (nums target)
  (block two-sum
    (let ((seen (py:->python (make-hash-table :test 'equal)))
          (py-nums (py:->python nums))
          (n (py:len (py:->python nums))))
      (dotimes (i n)
        (let* ((x (py:getitem py-nums i))
               (complement (- target x))
               (has-comp (py:call (py:attr seen "get") complement)))
          (if has-comp
              (return-from two-sum (list has-comp i))
              (py:call (py:attr seen "__setitem__") x i)))))))

(format t "Two Sum:~%")
(format t "  [2,7,11,15] t=9 => ~A~%" (two-sum '(2 7 11 15) 9))
(format t "  [3,2,4] t=6 => ~A~%" (two-sum '(3 2 4) 6))
