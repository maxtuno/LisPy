;; Test 6: @varname in Python f-strings

(defvar *name* "LisPy")
(defvar *version* 1)

msg = f"Hello from {@*name*} v{@*version*}"

(print @msg)

(assert (equal "Hello from LisPy v1" @msg))

(print "Test 6 (f-strings with @var): OK")
