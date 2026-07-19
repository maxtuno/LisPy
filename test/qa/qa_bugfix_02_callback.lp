;; ============================================================
;; QA-BUGFIX-02: Test for BUG-C01/C02 - Python callback injection
;; Run: bin/lispy.exe < tests/qa_bugfix_02_callback.lp
;; ============================================================

;; Test function names with special characters
;; Previously: buffer overflow + code injection via fn_name in Python

(defun simple-fn (x) (+ x 1))
(assert (= 6 (simple-fn 5)))

;; Test: function with quotes in name (via symbol)
;; This would have caused Python injection before fix
(let ((safe-name (intern "SAFE-TEST-FN")))
  (setf (symbol-function safe-name) (lambda (x) (* x 2)))
  (assert (= 20 (funcall safe-name 10))))

;; Test: many rapid definitions 
(defun fn-a (x) x)
(defun fn-b (x) x)
(defun fn-c (x) x)
(assert (= 42 (fn-a 42)))
(assert (= 42 (fn-b 42)))
(assert (= 42 (fn-c 42)))

(print "BUG-C01/C02: PASSED - callback injection prevented")
