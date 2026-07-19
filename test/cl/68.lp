;; CL-68: Digit character predicates
(defun string-classify (s)
  (format t "Classifying characters in \"~A\":~%" s)
  (loop for ch across s do
    (format t "  ~C: alpha=~A digit=~A alphanumeric=~A upper=~A lower=~A~%"
            ch
            (if (alpha-char-p ch) "yes" "no")
            (if (digit-char-p ch) "yes" "no")
            (if (alphanumericp ch) "yes" "no")
            (if (upper-case-p ch) "yes" "no")
            (if (lower-case-p ch) "yes" "no"))))

(string-classify "A1b2!?")
