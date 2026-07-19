;; CL-84: alphanumericp and string filters
(defun count-chars (s)
  (let ((alpha 0) (digit 0) (space 0) (other 0))
    (loop for ch across s do
      (cond ((alpha-char-p ch) (incf alpha))
            ((digit-char-p ch) (incf digit))
            ((char= ch #\Space) (incf space))
            (t (incf other))))
    (values alpha digit space other)))

(defun extract-words (s)
  (remove-if (lambda (w) (string= w ""))
             (split-string s #\Space)))

(let ((text "Hello123 World 42! Common Lisp 2024"))
  (multiple-value-bind (a d s o) (count-chars text)
    (format t "Text: ~A~%" text)
    (format t "  Letters: ~D~%" a)
    (format t "  Digits:  ~D~%" d)
    (format t "  Spaces:  ~D~%" s)
    (format t "  Other:   ~D~%" o))

  (format t "~%Filter - only alphabetic chars:~%")
  (format t "  ~A~%" (remove-if-not #'alpha-char-p text))

  (format t "~%Filter - only digits:~%")
  (format t "  ~A~%" (remove-if-not #'digit-char-p text)))

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
