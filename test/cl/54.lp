;; CL-54: Palindromes and string reversal
(defun palindrome-p (s)
  (string= s (reverse s)))

(defun longest-word (words)
  (reduce (lambda (a b) (if (> (length a) (length b)) a b)) words))

(let ((test-words '("radar" "hello" "level" "world" "madam" "lisp" "racecar"))
      (test-phrases '("a man a plan a canal panama" "was it a rat i saw")))
  (format t "Palindrome check on words:~%")
  (loop for w in test-words do
    (format t "  ~A: ~A~%" w (if (palindrome-p w) "Yes" "No")))
  
  (format t "~%Palindrome check on phrases (spaces removed):~%")
  (loop for p in test-phrases do
    (let ((clean (remove #\Space p)))
      (format t"  ~A~%" p)
      (format t"    Clean: ~A -> ~A~%" clean (if (palindrome-p clean) "Yes" "No"))))
  
  (format t "~%Longest word: ~A~%" (longest-word test-words)))
