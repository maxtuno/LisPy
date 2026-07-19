;;; python-template.lp — Generate Python code strings from Lisp forms

(defun template-atom (val)
  (cond
    ((null val) "None")
    ((eq val t) "True")
    ((numberp val) (write-to-string val))
    ((stringp val) val)
    ((symbolp val) (write-to-string val))
    (t (write-to-string val))))

(defun template-join (items sep)
  (let ((result ""))
    (dolist (item items)
      (when item
        (unless (string= result "")
          (setf result (concatenate 'string result sep)))
        (setf result (concatenate 'string result item))))
    result))

(defun template-args (args)
  (if (null args)
      ""
    (template-join (mapcar (lambda (a) (template-expr a 0)) args) ", ")))

(defun template-indent (level)
  (make-string (* level 4) :initial-element #\Space))

(defun template-expr (form level)
  (let ((pfx (template-indent level)))
    (cond
      ((atom form) (template-atom form))
      ((not (listp form)) (write-to-string form))
      (t
       (let* ((head (first form))
              (hname (if (symbolp head) (write-to-string head) "")))
         (cond
           ;; def NAME (ARGS) BODY...
           ((string-equal hname "def")
            (let ((name (template-atom (second form)))
                  (args (third form))
                  (body (nthcdr 3 form)))
              (format nil "~A~Adef ~A(~A):~%~{~A~^~%~}"
                      pfx (if (> level 0) "" "")
                      name
                      (template-args args)
                      (mapcar (lambda (b) (template-expr b (1+ level))) body))))
           
           ;; return EXPR
           ((string-equal hname "return")
            (format nil "~Areturn ~A" pfx (template-expr (second form) 0)))
           
           ;; := assignment
           ((string-equal hname ":=")
            (format nil "~A~A = ~A" pfx
                    (template-atom (second form))
                    (template-expr (third form) level)))
           
           ;; setq/setf assignment
           ((or (string-equal hname "SETQ") (string-equal hname "SETF"))
            (format nil "~A~A = ~A" pfx
                    (template-atom (second form))
                    (template-expr (third form) level)))
           
           ;; if COND THEN ELSE
           ((string-equal hname "if")
            (let ((cond-expr (template-expr (second form) 0))
                  (then-expr (template-expr (third form) (1+ level)))
                  (else-expr (if (fourth form)
                                 (template-expr (fourth form) (1+ level))
                               nil)))
              (if else-expr
                  (format nil "~Aif ~A:~%~A~%~Aelse:~%~A" pfx cond-expr then-expr pfx else-expr)
                (format nil "~Aif ~A:~%~A" pfx cond-expr then-expr))))
           
           ;; for VAR in EXPR BODY
           ((string-equal hname "for")
            (let* ((var (template-atom (second form)))
                   (rest (cddr form))
                   (iter-expr (template-expr (second rest) 0))
                   (body (nthcdr 2 rest)))
              (format nil "~Afor ~A in ~A:~%~{~A~^~%~}" pfx var iter-expr
                      (mapcar (lambda (b) (template-expr b (1+ level))) body))))
           
           ;; while COND BODY
           ((string-equal hname "while")
            (let ((cond-expr (template-expr (second form) 0))
                  (body (cddr form)))
              (format nil "~Awhile ~A:~%~{~A~^~%~}" pfx cond-expr
                      (mapcar (lambda (b) (template-expr b (1+ level))) body))))
           
           ;; lambda (ARGS) BODY
           ((string-equal hname "LAMBDA")
            (let ((args (cdr (second form)))
                  (body (cddr form)))
              (format nil "~Alambda ~A: ~A" pfx
                      (template-args args)
                      (template-join (mapcar (lambda (b) (template-expr b level)) body) "; "))))
           
           ;; print ARGS
           ((string-equal hname "PRINT")
            (format nil "~Aprint(~A)" pfx (template-args (cdr form))))
           
           ;; . OBJ METHOD ARGS → OBJ.METHOD(ARGS)
           ((string-equal hname ".")
            (let ((obj (template-expr (second form) level))
                  (method (template-atom (third form))))
              (format nil "~A~A.~A(~A)" pfx obj method
                      (template-args (nthcdr 3 form)))))
           
           ;; aref ARRAY IDX → ARRAY[IDX]
           ((string-equal hname "AREF")
            (format nil "~A~A[~A]" pfx
                    (template-expr (second form) level)
                    (template-args (cddr form))))
           
           ;; Binary operators: + - * / ** // %
           ((or (string-equal hname "+") (string-equal hname "-")
                (string-equal hname "*") (string-equal hname "/")
                (string-equal hname "**") (string-equal hname "//")
                (string-equal hname "%"))
            (if (= (length (cdr form)) 1)
                (format nil "~A~A" hname (template-expr (second form) 0))
              (template-join
               (mapcar (lambda (x) (template-expr x 0)) (cdr form))
               (concatenate 'string " " hname " "))))
           
           ;; Comparisons
           ((or (string-equal hname "<=") (string-equal hname ">=")
                (string-equal hname "<") (string-equal hname ">")
                (string-equal hname "==") (string-equal hname "!="))
            (format nil "~A~A ~A ~A" pfx
                    (template-expr (second form) 0)
                    hname
                    (template-expr (third form) 0)))
           
           ;; Generic function call
           (t
            (format nil "~A~A(~A)" pfx
                    (template-expr head 0)
                    (template-args (cdr form)))))))))
  )

(defun python-template (form &key (indent 0))
  "Convert Lisp form to Python string."
  (template-expr form indent))

(defmacro write-python-template (form)
  `(python-template ,form))
