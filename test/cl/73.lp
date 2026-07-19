;; CL-73: Search and replace in strings
(defun replace-in-string (str old new)
  (let* ((old-len (length old))
         (pos (search old str)))
    (if pos
        (concatenate 'string
                     (subseq str 0 pos)
                     new
                     (subseq str (+ pos old-len)))
        str)))

(format t "subseq examples:~%")
(format t "  First 9 chars: ~A~%" (subseq "Hello, World!" 0 9))
(format t "  Last 6 chars:  ~A~%" (subseq "Hello, World!" 7))

(let ((text "The quick brown fox jumps over the lazy dog"))
  (format t "~%Original: ~A~%" text)
  (format t "Replace 'fox' with 'cat':~%")
  (format t "  ~A~%" (replace-in-string text "fox" "cat"))
  (format t "~%Replace 'lazy' with 'sleepy':~%")
  (format t "  ~A~%" (replace-in-string text "lazy" "sleepy")))
