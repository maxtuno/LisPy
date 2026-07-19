;; QA-02: String and f-string edge cases

;; --- @ inside Python double-quoted string (should be literal) ---
s1 = "email@domain.com"
(assert (equal "email@domain.com" (py:->lisp @s1)))
(print "QA-02a: @ in double-quoted string OK")

;; --- @ inside single-quoted string (should be literal) ---
s2 = 'user@host'
(assert (equal "user@host" (py:->lisp @s2)))
(print "QA-02b: @ in single-quoted string OK")

;; --- @ inside f-string double-quoted ---
(defvar *name* "Kilo")
msg1 = f"Hello {@*name*}!"
(assert (equal "Hello Kilo!" @msg1))
(print "QA-02c: @var in f-string double-quote OK")

;; --- @ inside f-string single-quoted ---
msg2 = f'Hi {@*name*}!'
(assert (equal "Hi Kilo!" @msg2))
(print "QA-02d: @var in f-string single-quote OK")

;; --- @ in triple-quoted string (should be literal) ---
s3 = """email@test.com"""
(assert (equal "email@test.com" (py:->lisp @s3)))
(print "QA-02e: @ in triple-double-quoted string OK")

;; --- @ in single triple-quoted string ---
s4 = '''test@host'''
(assert (equal "test@host" (py:->lisp @s4)))
(print "QA-02f: @ in triple-single-quoted string OK")

(print "QA-02: ALL STRING TESTS DONE")
