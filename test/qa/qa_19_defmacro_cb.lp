;; Test: builtins.XXX = XXX_cb exposure verification
(print "-- executing qa_19 --")

(defun square (x) (* x x))

;; Python block uses square() which was auto-registered
r = square(7)

;; Read back via @ reader macro
(assert (= 49 @r))

;; Verify builtins.square exists (via Python)
(py:run "
import builtins
assert hasattr(builtins, 'square_cb'), 'square_cb missing'
assert hasattr(builtins, 'square'), 'square missing'
print('builtins.square OK')
")

(print "qa_19: OK")
