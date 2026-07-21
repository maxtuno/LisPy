(defun single-non-duplicate (nums)
  (let ((py-nums (py:->python nums))
        (n (py:len (py:->python nums))))
    (loop for i from 0 below (- n 1) by 2
          do (let ((a (py:getitem py-nums i))
                   (b (py:getitem py-nums (1+ i))))
               (when (/= a b)
                 (return-from single-non-duplicate a))))
    (py:getitem py-nums (1- n))))

(format t "Single Element in Sorted Array:~%")
(format t "  [1,1,2,3,3,4,4,8,8] => ~A~%" (single-non-duplicate '(1 1 2 3 3 4 4 8 8)))
(format t "  [3,3,7,7,10,11,11] => ~A~%" (single-non-duplicate '(3 3 7 7 10 11 11)))
