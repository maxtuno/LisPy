;; CL-85: Complement - logical inverse of a predicate
;; Uses manual partitioning to demonstrate predicate inversion

(let ((nums '(-3 -2 -1 0 1 2 3))
      (even-numbers '())
      (odd-numbers '())
      (non-neg-numbers '())
      (neg-numbers '()))
  (dolist (n nums)
    (when (evenp n) (push n even-numbers))
    (when (not (evenp n)) (push n odd-numbers))
    (when (>= n 0) (push n non-neg-numbers))
    (when (< n 0) (push n neg-numbers)))
  
  (format t "Numbers: ~A~%" nums)
  (format t "~%Even numbers:  ~A~%" (reverse even-numbers))
  (format t "Odd numbers:   ~A~%" (reverse odd-numbers))
  (format t "Non-negative:  ~A~%" (reverse non-neg-numbers))
  (format t "Negative:      ~A~%" (reverse neg-numbers)))

(format t "~%Complement concept: (lambda (x) (not (pred x)))~%")
(format t "  oddp on 3: ~A~%" (not (evenp 3)))
(format t "  oddp on 4: ~A~%" (not (evenp 4)))
