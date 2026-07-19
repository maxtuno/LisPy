;; Test 7: @var in single-quoted f-strings (Bug: nested quotes conflict)
;; The preprocessor replaces @var with builtins.lispy_callback_c('var')
;; which breaks when the f-string already uses single quotes.

(defvar *name* "LisPy")

msg = f'Hello, {@*name*}!'

(print @msg)

(assert (equal "Hello, LisPy!" @msg))

(print "Test 7 (f-strings single-quote): OK")
