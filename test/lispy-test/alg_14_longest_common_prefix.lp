(defun longest-common-prefix (strs)
  (let ((n (length strs)))
    (if (= n 0)
        ""
        (let ((first-str (elt strs 0))
              (result (elt strs 0)))
          (block outer
            (dotimes (si (1- n))
              (let ((idx (1+ si)))
                (let ((cur-str (elt strs idx))
                      (cur-match 0)
                      (limit (min (length result) (length (elt strs idx)))))
                  (block inner
                    (dotimes (j limit)
                      (if (char= (char result j) (char cur-str j))
                          (incf cur-match)
                          (return-from inner))))
                  (setf result (subseq result 0 cur-match)))))
            result)))))

(format t "Longest Common Prefix:~%")
(format t "  [flower,flow,flight] => ~S~%" (longest-common-prefix #("flower" "flow" "flight")))
(format t "  [dog,racecar,car] => ~S~%" (longest-common-prefix #("dog" "racecar" "car")))
