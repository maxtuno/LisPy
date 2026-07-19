;; CL-83: String tokenization and splitting
(defun split-string (str &optional (delimiter #\Space))
  (let ((words '())
        (start 0))
    (loop for i from 0 below (length str) do
      (when (char= (char str i) delimiter)
        (when (> i start)
          (push (subseq str start i) words))
        (setf start (+ i 1))))
    (when (> (length str) start)
      (push (subseq str start) words))
    (reverse words)))

(defun join-strings (lst &optional (separator " "))
  (if (null lst)
      ""
      (reduce (lambda (a b) (concatenate 'string a separator b)) lst)))

(let ((sentence "The quick brown fox")
      (csv "apple,banana,cherry,date"))
  (format t "Split \"~A\" by space: ~A~%" sentence (split-string sentence))
  (format t "Split \"~A\" by comma: ~A~%" csv (split-string csv #\,))
  
  (format t "~%Join back: ~S~%" (join-strings '("a" "b" "c") ","))
  (format t "Join back: ~S~%" (join-strings '("one" "two" "three") " - ")))
