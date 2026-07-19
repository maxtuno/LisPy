;;; defpyclass.lp — Synchronized Lisp + Python class definitions

(defmacro defpyclass (name slots &key python-class-name python-methods)
  "Define a synchronized Lisp + Python class."
  (let* ((py-name (or python-class-name (write-to-string name)))
         (slot-symbols (mapcar (lambda (s)
                                 (if (listp s) (first s) s))
                               slots))
         (slot-strings (mapcar #'write-to-string slot-symbols))
         (init-params (format nil "~{~A~^, ~}" slot-strings))
         (init-body (format nil "~{        self.~A = ~A~%~}" (mapcan (lambda (s) (list s s)) slot-strings)))
         (methods-code "")
         (py-code-str (format nil "class ~A:
    def __init__(self, ~A):
~A~A" py-name init-params init-body methods-code)))
    ;; Python methods: skipped for now (requires dotted pair support in LisPy)
    #+nil
    (let ((entries python-methods))
      (when entries
        (setf py-code-str (concatenate 'string py-code-str "    pass~%"))))
    ;; Return expanded form
    `(progn
       (defclass ,name () (,@slots (py-instance :accessor py-of)))
       (py:run ,py-code-str)
       (setf (get ',name 'python-class) (py:attr (py:import "__main__") ,py-name))
       (defun ,(read-from-string (format nil "MAKE-~A" (write-to-string name))) (&rest initargs)
         (let ((lisp-obj (make-instance ',name))
               (py-obj (py:call (get ',name 'python-class)
                                ,@(mapcar (lambda (s) (declare (ignore s)) nil) slot-symbols))))
           ;; Transfer initargs to both sides
           ,@(mapcar (lambda (slot)
                      (let ((slot-str (write-to-string slot)))
                        `(let ((val (getf initargs ,(read-from-string (format nil ":~A" slot-str)) nil)))
                           (when val
                             (setf (slot-value lisp-obj ',slot) val)
                             (py:%set-attr py-obj ,slot-str (py:->python val))))))
                    slot-symbols)
           (setf (slot-value lisp-obj 'py-instance) py-obj)
           lisp-obj)))))

(defun py:instance (lisp-obj)
  "Get the Python instance associated with a Lisp CLOS object."
  (slot-value lisp-obj 'py-instance))
