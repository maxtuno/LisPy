;; QA-07: Multiple Lisp definitions with various naming conventions

(defun sq (x) (* x x))
(defun db (x) (* x 2))

r = sq(db(5))

(assert (= 100 (py:->lisp @r)))
(print "QA-07a: simple names OK")

;; --- Function with numbers in name ---
(defun add2 (x) (+ x 2))
(defun mul3 (x) (* x 3))

r2 = add2(mul3(10))
(assert (= 32 (py:->lisp @r2)))
(print "QA-07b: numeric names OK")

;; --- Star/earmuff names via callback ---
(defvar *global-counter* 0)
(defun incglobal ()
  (setf *global-counter* (+ *global-counter* 1))
  *global-counter*)

x = incglobal()
y = incglobal()

(assert (= 2 (py:->lisp @y)))
(print "QA-07c: global state OK")

;; --- Mixed case names ---
(defun MixedCase (x) (* x x))

r3 = MixedCase(8)
(assert (= 64 (py:->lisp @r3)))
(print "QA-07d: mixed case OK")

(print "QA-07: NAMING TESTS DONE")
