;;; defpyfun.lp — Define Python functions from Lisp with variable capture

(defun defpyfun (name arglist body &key capture)
  "Define a Python function, capturing Lisp values as Python constants.
   
   NAME:     function name (symbol or string)
   ARGLIST:  list of Python argument names (x y z)
   BODY:     Python function body as string. Use CAPTURED_<varname> for injected values.
   :CAPTURE: alist mapping Python var names to Lisp expressions
             e.g.: '((\"factor\" . my-lisp-var) (\"offset\" . 10))
   
   Returns the Python callable.
   
   Example:
     (let ((fn (defpyfun 'scale '(x) \"return x * CAPTURED_factor\"
                         :capture '((\"factor\" . 3.14)))))
       (py:call fn 10))  ;; → 31.4"
  (let* ((name-str (if (symbolp name) (write-to-string name) name))
         (args-str (if arglist
                       (let ((names (mapcar #'write-to-string arglist)))
                         (reduce (lambda (a b) (concatenate 'string a ", " b)) names))
                     ""))
         (capture-code ""))
    ;; Generate Python code for each captured variable
    (dolist (entry capture)
      (let* ((py-name (car entry))
             (lisp-val (cdr entry))
             (py-repr (py:repr (py:->python lisp-val))))
        (setf capture-code
              (concatenate 'string capture-code
                           (format nil "    CAPTURED_~A = ~A~%" py-name py-repr)))))
    ;; Build full Python function
    (let ((py-code
           (if (string= capture-code "")
               (format nil "def ~A(~A):~%    ~A~%" name-str args-str body)
             (format nil "def ~A(~A):~%~A    ~A~%" name-str args-str capture-code body))))
      (py:run py-code)
      (py:attr (py:import "__main__") name-str))))
