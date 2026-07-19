(defun euler-1 ()
  (loop for i from 1 below 1000
        when (or (= (mod i 3) 0) (= (mod i 5) 0)) sum i))
