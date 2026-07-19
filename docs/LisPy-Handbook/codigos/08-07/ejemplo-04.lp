(defun test-both (test-case)
  (let ((py-result (process-data-py (first test-case) (second test-case)))
        (lisp-result (process-data-lisp (first test-case) (second test-case))))
    (assert (equal py-result lisp-result))))
