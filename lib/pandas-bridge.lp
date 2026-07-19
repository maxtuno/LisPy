;;; pandas-bridge.lp --- Operaciones de DataFrames con pandas desde Lisp
;;;
;;; Proporciona funciones para crear, explorar, filtrar, agrupar y visualizar
;;; DataFrames de pandas desde Lisp.
;;;
;;; Dependencias: numpy-fast.lp (para numpy-array)

(provide 'pandas-bridge)

(in-package :cl-user)

;; --- Inicialización lazy ---
(defvar *pandas-init* nil)

(defun pandas-init ()
  (unless *pandas-init*
    (py:import "pandas")
    (py:import "numpy")
    (setf *pandas-init* t)))

;; --- Creación de DataFrames ---
(defun pandas-dataframe (data &key columns index)
  (pandas-init)
  (if (and (listp data) (listp (first data)))
      (let ((arr (py:->python data)))
        (py:call-kw (py:attr pandas "DataFrame")
                    (list arr)
                    (let ((kwargs (make-hash-table :test 'equal)))
                      (when columns
                        (setf (gethash "columns" kwargs) (py:->python columns)))
                      (when index
                        (setf (gethash "index" kwargs) (py:->python index)))
                      kwargs)))
      (error "pandas-dataframe: data must be a list of lists")))

(defun pandas-read-csv (filepath &key separator header)
  (pandas-init)
  (let ((kwargs (make-hash-table :test 'equal)))
    (when separator
      (setf (gethash "sep" kwargs) separator))
    (when header
      (setf (gethash "header" kwargs) (if header 0 nil)))
    (py:call-kw (py:attr pandas "read_csv")
               (list filepath)
               kwargs)))

;; --- Exploración ---
(defun pandas-head (df &optional (n 5))
  (py:call (py:attr df "head") n))

(defun pandas-info (df)
  (py:call (py:attr df "info")))

(defun pandas-describe (df)
  (py:call (py:attr df "describe")))

;; --- Selección ---
(defun pandas-select (df columns)
  (py:getitem df (py:->python columns)))

;; --- Filtrado ---
(defun pandas-filter (df predicate)
  (let ((mask (py:call (py:attr df "apply")
                      (py:->python
                       (lambda (row)
                         (if (funcall predicate row) t nil))
                       :axis 1))))
    (py:call (py:attr df "loc") mask)))

;; --- Agrupación ---
(defun pandas-groupby (df by &key aggregations)
  (let* ((grouped (py:call (py:attr df "groupby") (py:->python by)))
         (aggs (make-hash-table :test 'equal)))
    (when aggregations
      (dolist (agg aggregations)
        (let ((col (car agg))
              (func (cdr agg)))
          (setf (gethash col aggs) func))))
    (if (> (hash-table-count aggs) 0)
        (py:call (py:attr grouped "agg") (py:->python aggs))
        grouped)))

;; --- Ordenamiento ---
(defun pandas-sort (df by &key ascending)
  (py:call-kw (py:attr df "sort_values")
             (list (py:->python by))
             (let ((kwargs (make-hash-table :test 'equal)))
               (when ascending
                 (setf (gethash "ascending" kwargs)
                       (if ascending t nil)))
               kwargs)))

;; --- Conversión a Lisp ---
(defun pandas-to-list (df)
  (py:->lisp (py:call (py:attr df "values")
                      :tolist)))

;; --- Visualización ---
(defun pandas-plot (df &key kind x y title figsize)
  (let ((kwargs (make-hash-table :test 'equal)))
    (when kind (setf (gethash "kind" kwargs) kind))
    (when x (setf (gethash "x" kwargs) x))
    (when y (setf (gethash "y" kwargs) y))
    (when title (setf (gethash "title" kwargs) title))
    (when figsize (setf (gethash "figsize" kwargs) (py:->python figsize)))
    (py:call-kw (py:attr df "plot")
               nil
               kwargs)
    (let ((plt (py:import "matplotlib.pyplot")))
      (py:call (py:attr plt "show")))))

;; --- Join ---
(defun pandas-join (left right &key on how)
  (let ((kwargs (make-hash-table :test 'equal)))
    (when on (setf (gethash "on" kwargs) on))
    (when how (setf (gethash "how" kwargs) how))
    (py:call-kw (py:attr pandas "merge")
               (list left right)
               kwargs)))

(format t "pandas-bridge loaded~%")
