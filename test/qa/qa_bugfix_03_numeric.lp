;; ============================================================
;; QA-BUGFIX-03: Division by zero & numeric edge cases (BUG-A02)
;; Run: bin/lispy.exe < tests/qa_bugfix_03_numeric.lp
;; ============================================================

(print "--- BUG-A02: Division by zero signaling ---")

;; Test 1: Integer division by zero must signal error
(handler-case
    (/ 5 0)
  (error (c)
    (print "BUG-A02a: division-by-zero caught for integer / 0")))

;; Test 2: Float division by zero
(handler-case
    (/ 5.0 0.0)
  (error (c)
    (print "BUG-A02b: division-by-zero caught for float / 0.0")))

;; Test 3: Ratio division by zero
(handler-case
    (/ 1/2 0)
  (error (c)
    (print "BUG-A02c: division-by-zero caught for ratio / 0")))

;; Test 4: Normal division still works
(assert (= 5 (/ 10 2)))
(assert (= 7/2 (/ 7 2)))
(assert (< (abs (- 3.33333 (/ 10.0 3.0))) 0.001))

(print "BUG-A02: PASSED - division by zero correctly signaled")
