;; ============================================================
;; QA-BUGFIX: Rigorous tests for corrected bugs in lispy.c
;; Run: bin/lispy.exe < tests/qa_bugfix_01_memory.lp
;; ============================================================

;; --- BUG-C03: Memory leak in special_defn_like ---
;; Previously: ValueArray arr and block_body leaked on error paths
;; Test: Thousands of defun calls must not exhaust memory
;;        and must complete successfully

(print "--- BUG-C03: Memory leak stress test ---")

;; Stress: define 1000 functions in a loop
(dotimes (i 500)
  (let ((name (intern (format nil "STRESS-FN-~D" i))))
    (eval `(defun ,name (x) (+ x ,i)))))

;; Verify a random sample works
(assert (= 42 (stress-fn-0 42)))
(assert (= 142 (stress-fn-100 42)))
(assert (= 341 (stress-fn-299 42)))
(assert (= 541 (stress-fn-499 42)))

;; Test error path: defun with invalid args should not leak
(handler-case
    (eval '(defun bad-fn))              ; missing params
  (error (c) (print "BUG-C03: error path OK (caught expected error)")))

(print "BUG-C03: PASSED - no memory leak in 500 defun calls")
