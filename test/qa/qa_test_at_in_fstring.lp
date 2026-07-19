;; QA: Test @ syntax inside f-strings

(defvar *name* "LisPy")

msg = f"Hello from {@*name*}"
(print @msg)

msg2 = f'Hello from {@*name*}'
(print @msg2)

(print "QA Complete")
