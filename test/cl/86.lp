;; CL-86: loop with named blocks and conditional collect
(defun loop-advanced-demo ()
  (let ((data '((1 . "one") (2 . "two") (3 . "three") 
                (4 . "four") (5 . "five"))))
    (format t "Picking only numbers > 2 and < 5:~%")
    (let ((filtered
           (loop named outer
                 for (n . name) in data
                 when (> n 5) do (return-from outer nil)
                 when (and (> n 2) (< n 5))
                 collect (list n name))))
      (format t "  ~A~%" filtered)))
  
  (format t "~%Multi-collection ~%")
  (loop for i from 1 to 10
        when (evenp i) collect i into evens
        when (oddp i) collect i into odds
        finally
        (format t "  Evens: ~A~%" evens)
        (format t "  Odds:  ~A~%" odds)))

(loop-advanced-demo)
