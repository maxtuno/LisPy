;;; continuations.lp — Lisp↔Python generator/coroutine bridge

(defun py:gen-next (gen)
  "Get next value from a Python generator. Returns nil when exhausted."
  (let ((blt (py:import "builtins")))
    (py:call (py:attr blt "next") gen nil)))

(defun py:gen-send (gen value)
  "Send a value to a Python generator, return the yielded value."
  (py:call (py:attr gen "send") (py:->python value)))

(defun py:gen-close (gen)
  "Close a Python generator."
  (py:call (py:attr gen "close")))

(provide "continuations")
