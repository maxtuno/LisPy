;; CL-34: Type predicates
(defun type-predicate-demo ()
  (let ((values '(42 3.14 "hello" (1 2 3) t nil #\a #'car)))
    (format t "Value          | numberp | integerp | stringp | listp | symbolp~%")
    (format t "---------------|---------|----------|---------|-------|--------~%")
    (dolist (v values)
      (format t "~15A | ~7A | ~8A | ~7A | ~5A | ~7A~%"
              (format nil "~A" v)
              (if (numberp v) "yes" "no")
              (if (integerp v) "yes" "no")
              (if (stringp v) "yes" "no")
              (if (listp v) "yes" "no")
              (if (symbolp v) "yes" "no")))))

(type-predicate-demo)
