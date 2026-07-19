;; CL-45: Caesar cipher with character manipulation
(defun char-shift (ch n)
  (let* ((code (char-code ch))
         (base (char-code #\a))
         (shifted (+ (- code base) n))
         (wrapped (mod shifted 26)))
    (code-char (+ base wrapped))))

(defun caesar-encrypt (text shift)
  (map 'string
       (lambda (ch)
         (if (alpha-char-p ch)
             (char-shift (char-downcase ch) shift)
             ch))
       text))

(let ((original "hello world")
      (shift 3))
  (format t "Original:  ~A~%" original)
  (format t "Encrypted: ~A~%" (caesar-encrypt original shift)))
