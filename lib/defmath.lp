;;; defmath.lp — Hybrid symbolic-numeric mathematics macro

;; Auto-load dependencies
(load "lib/sympy-bridge.lp")

(defmacro defmath (name args &rest body)
  "Define a mathematical function with symbolic and numeric variants.
   Generates NAME-sym (SymPy) and NAME-num (NumPy)."
  (let ((name-str (write-to-string name))
        (sym-body `(sympy-expr ',(first body)))
        (num-body (defmath-numexpr (first body))))
    (let ((sym-name (read-from-string (format nil "~A-SYM" name-str)))
          (num-name (read-from-string (format nil "~A-NUM" name-str))))
      `(progn
         (defun ,sym-name ,args ,sym-body)
         (defun ,num-name ,args ,num-body)))))

(defun defmath-numexpr (form)
  "Convert Lisp arithmetic form to NumPy expression."
  (cond
    ((numberp form) form)
    ((symbolp form) form)
    ((and (listp form) (>= (length form) 2))
     (let* ((op (write-to-string (first form)))
            (sub (mapcar #'defmath-numexpr (rest form))))
       (cond
         ((string= op "+") `(numpy-add ,@sub))
         ((string= op "-")
          (if (= (length sub) 1)
              `(numpy-neg ,(first sub))
            `(numpy-sub ,(first sub) ,(second sub))))
         ((string= op "*") `(numpy-mul ,@sub))
         ((string= op "/") `(numpy-div ,(first sub) ,(second sub)))
         ((string= op "EXPT") `(numpy-pow ,(first sub) ,(second sub)))
         ((string= op "SQRT") `(numpy-sqrt ,(first sub)))
         ((string= op "SIN") `(numpy-sin ,(first sub)))
         ((string= op "COS") `(numpy-cos ,(first sub)))
         ((string= op "LOG") `(numpy-log ,(first sub)))
         ((string= op "EXP") `(numpy-exp ,(first sub)))
         (t `(numpy-generic ,op ,@sub)))))
    (t form)))

;; Ensure _sop helper exists (used by both sympy-bridge and numpy ops)
(defvar *math-helpers-ready* nil)

(defun math-ensure-helpers ()
  (unless *math-helpers-ready*
    (setf *math-helpers-ready* t)
    (py:run "import numpy as _np
def _sop(op, arglist):
    return getattr(_np, op)(*arglist)") t))

;; NumPy operations
(defun numpy-add (&rest args) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "add" (py:->python (listify args)))))

(defun numpy-sub (a b) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "subtract" (py:->python (list a b)))))

(defun numpy-mul (&rest args) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "multiply" (py:->python (listify args)))))

(defun numpy-div (a b) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "divide" (py:->python (list a b)))))

(defun numpy-pow (a b) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "power" (py:->python (list a b)))))

(defun numpy-sqrt (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "sqrt" (py:->python (list a)))))

(defun numpy-neg (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "negative" (py:->python (list a)))))

(defun numpy-sin (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "sin" (py:->python (list a)))))

(defun numpy-cos (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "cos" (py:->python (list a)))))

(defun numpy-log (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "log" (py:->python (list a)))))

(defun numpy-exp (a) (math-ensure-helpers)
  (let ((m (py:import "__main__")))
    (py:call (py:attr m "_sop") "exp" (py:->python (list a)))))

(defun listify (lst)
  "Convert dotted list to proper list."
  (if (null lst) nil
    (cons (car lst) (listify (cdr lst)))))

(provide "defmath")
