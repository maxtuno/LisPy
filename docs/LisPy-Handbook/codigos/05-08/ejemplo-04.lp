(macroexpand-1 '(defmath sq (x) (* x x)))
;; Expande a:
;; (progn (defun sq ...) (defun sq-sym ...) (defun sq-num ...)
;;        (defparameter *sq-meta* ...))
