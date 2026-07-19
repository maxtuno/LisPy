;; quick_test.lp
(handler-case (/ 1 0) (division-by-zero (c) (format t "OK~%" c)))
(handler-bind ((warning #'(lambda (c) (format t "OK~%")))) (warn "test"))
