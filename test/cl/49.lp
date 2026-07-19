;; CL-49: GCD and LCM
(defun my-gcd (a b)
  (if (zerop b)
      (abs a)
      (my-gcd b (mod a b))))

(defun my-lcm (a b)
  (/ (abs (* a b)) (my-gcd a b)))

(let ((pairs '((12 8) (17 23) (48 180) (0 5) (-24 36))))
  (format t "~5A ~5A | ~5A ~5A~%" "a" "b" "gcd" "lcm")
  (format t "--------------------~%")
  (loop for (a b) in pairs do
    (format t "~5D ~5D | ~5D ~5D~%" a b (my-gcd a b) (my-lcm a b))))
