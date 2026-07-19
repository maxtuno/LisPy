;;; sympy-bridge.lp — Symbolic mathematics via SymPy from Lisp

(defvar *sympy-init* nil)

(defun sympy-init ()
  (unless *sympy-init*
    (setf *sympy-init* t)
    (py:run "import sympy")  ;; Import via py:run (faster than py:import for first import)
    (py:run "import sympy
def _sop(op, arglist):
    return getattr(sympy, op)(*arglist)
def _sneg(x):
    return -x
def _sdiff(expr, var, n):
    return sympy.diff(expr, var, n)
def _sint(expr, var):
    return sympy.integrate(expr, var)
def _ssimp(expr):
    return sympy.simplify(expr)
def _sevalf(expr):
    return expr.evalf()
")))

(defun sympy-symbol (name)
  (sympy-init)
  (let ((sp (py:import "sympy")))
    (py:call (py:attr sp "symbols") name)))

(defun sympy-expr (form)
  "Convert a Lisp arithmetic form to a SymPy expression."
  (sympy-init)
  (let ((main (py:import "__main__")))
    (cond
      ((numberp form) (py:->python form))
      ((and (listp form) (>= (length form) 2))
       (let* ((op (write-to-string (first form)))
              (args (mapcar #'sympy-expr (rest form))))
         (cond
           ((string= op "+")
            (py:call (py:attr main "_sop") "Add" (py:->python args)))
           ((string= op "-")
            (if (= (length args) 1)
                (py:call (py:attr main "_sneg") (first args))
              (py:call (py:attr main "_sop") "Add"
                       (py:->python (list (first args)
                                          (py:call (py:attr main "_sneg") (second args)))))))
           ((string= op "*")
            (py:call (py:attr main "_sop") "Mul" (py:->python args)))
           ((string= op "/")
            (py:call (py:attr main "_sop") "Pow" (py:->python (list (first args) (py:->python -1)))))
           ((string= op "EXPT")
            (py:call (py:attr main "_sop") "Pow" (py:->python args)))
           ((string= op "SQRT")
            (py:call (py:attr main "_sop") "sqrt" (py:->python (list (first args)))))
           ((string= op "SIN")
            (py:call (py:attr main "_sop") "sin" (py:->python (list (first args)))))
           ((string= op "COS")
            (py:call (py:attr main "_sop") "cos" (py:->python (list (first args)))))
           ((string= op "LOG")
            (py:call (py:attr main "_sop") "log" (py:->python args)))
           ((string= op "EXP")
            (py:call (py:attr main "_sop") "exp" (py:->python (list (first args)))))
           (t (py:->python form)))))
      (t (py:->python form)))))

(defun sympy-derive (expr var &optional (n 1))
  (sympy-init)
  (py:call (py:attr (py:import "__main__") "_sdiff") expr var n))

(defun sympy-integrate (expr var)
  (sympy-init)
  (py:call (py:attr (py:import "__main__") "_sint") expr var))

(defun sympy-simplify (expr)
  (sympy-init)
  (py:call (py:attr (py:import "__main__") "_ssimp") expr))

(defun sympy-evalf (expr)
  (sympy-init)
  (py:call (py:attr (py:import "__main__") "_sevalf") expr))

(defun sympy-latex (expr)
  (sympy-init)
  (let ((sp (py:import "sympy")))
    (py:str (py:call (py:attr sp "latex") expr))))
