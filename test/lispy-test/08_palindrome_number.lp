(defun palindrome-number (x)
  (if (< x 0)
      nil
      (let* ((s (py:str (py:->python x)))
             (py-join (py:attr (py:->python "") "join"))
             (rev (py:call py-join (py:reversed s))))
        (equal s rev))))

(format t "Palindrome Number:~%")
(format t "  121 => ~A~%" (palindrome-number 121))
(format t "  -121 => ~A~%" (palindrome-number -121))
(format t "  10 => ~A~%" (palindrome-number 10))
(format t "  12321 => ~A~%" (palindrome-number 12321))
