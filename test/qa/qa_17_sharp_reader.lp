;; Test: Python FFI advanced features
(py:import "math")

;; py:call-kw with hash-table (signature: callable kwargs &rest args)
(print "-- call-kw --")
(let ((kw (make-hash-table)))
  (setf (gethash "sep" kw) "|")
  (py:call-kw (py:attr (py:import "builtins") "print") kw "a" "b" "c"))

;; py:pickle-dumps and py:pickle-loads round-trip
(print "-- pickle --")
(let* ((orig (py:->python (list 1 2 3 4 5)))
       (hex (py:pickle-dumps orig))
       (restored (py:pickle-loads hex))
       (lisp-restored (py:->lisp restored)))
  (print lisp-restored))

;; py:dir first 5 attrs
(let ((attrs (py:dir (py:import "math"))))
  (print (subseq attrs 0 (min 5 (length attrs)))))

;; py:type and py:repr
(let ((m (py:import "math")))
  (print (py:type m))
  (print (py:repr m)))

;; py:len
(let ((nums (py:->python (list 1 2 3 4 5))))
  (print (py:len nums)))

;; py:str
(print (py:str (py:->python 42)))

(print "qa_17: OK")
