;; Test: Edge cases around hybrid callback system
(print "-- executing qa_21 --")

;; Edge case: function defined but never called from Python (no-op)
(defun never-used (x) (* x x))

;; Edge case: defvar auto-resolution
(defparameter *pi* 3.14159)
pi_val = builtins.lispy_callback_c('*pi*')

(print @pi_val)

;; Edge case: @ variable that doesn't exist - should error gracefully
(handler-case
    (progn @nonexistent_var (print "unexpected success"))
  (error (e) (print "expected error caught")))

(print "qa_21: OK")
