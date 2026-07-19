;; Test 5: Python block only (no Lisp defuns)

m = 42

(assert (= 42 (py:->lisp @m)))

r = 0
for i in range(5):
    r = r + i * i

(assert (= 30 (py:->lisp @r)))

(print "Test 5 (Python-only blocks): OK")
