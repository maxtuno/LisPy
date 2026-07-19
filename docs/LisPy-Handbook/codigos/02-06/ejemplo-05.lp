(define-condition malformed-input (error) ((input :initarg :input)))
(error 'malformed-input :input "bad!")
