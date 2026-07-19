;; CL-89: Recursive descent - simple arithmetic expression evaluator
;; Evaluates expressions like (+ 1 (* 2 3)) recursively

(defun eval-expr (expr)
  (if (atom expr)
      expr
      (let ((op (car expr))
            (args (cdr expr)))
        (case op
          (* (apply #'* (mapcar #'eval-expr args)))
          (+ (apply #'+ (mapcar #'eval-expr args)))
          (- (apply #'- (mapcar #'eval-expr args)))
          (/ (apply #'/ (mapcar #'eval-expr args)))
          (sqrt (sqrt (eval-expr (car args))))
          (square (let ((val (eval-expr (car args)))) (* val val)))
          (otherwise (format nil "Unknown op: ~A" op))))))

(let ((tests '((+ 1 2 3 4 5)
               (* 2 3 4)
               (- 100 (+ 30 20))
               (/ 100 2 5)
               (sqrt 144)
               (square 7)
               (+ (* 2 3) (* 4 5) (- 10 5))
               (* (+ 1 2) (+ 3 4)))))
  (format t "Simple expression evaluator:~%")
  (dolist (expr tests)
    (format t "  ~A => ~A~%" expr (eval-expr expr))))
