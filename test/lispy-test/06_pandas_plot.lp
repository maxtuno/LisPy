;;; ============================================================
;;; LisPy Advanced 06 — Pandas: Advanced Data Pipeline
;;; Pure py: API — groupby, aggregations, joins, filtering
;;; ============================================================

(format t "~%=== LisPy + Pandas: Advanced Pipeline ===~%~%")

(let* ((pd (py:import "pandas"))
       (np (py:import "numpy"))
       (array (py:attr np "array")))

  (format t "[1] Multi-column DataFrame~%")
  (let* ((data (py:call array (py:->python '((25 75000 0) (30 82000 1) (28 68000 0)
                                             (35 95000 1) (22 62000 2) (27 78000 2)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary" "dept")))
    (format t "~A~%~%" (py:str df)))

  (format t "[2] GroupBy Aggregations (Lisp-driven)~%")
  (let* ((data (py:call array (py:->python '((25 75000 0) (30 82000 1) (28 68000 0)
                                             (35 95000 1) (22 62000 2) (27 78000 2)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary" "dept")))
    (let* ((grouped (py:call (py:attr df "groupby") "dept"))
           (agg (py:call (py:attr grouped "agg")
                         (py:call (py:attr (py:import "builtins") "list")
                                  (py:->python '("mean" "min" "max"))))))
      (format t "  Grouped by department:~%~A~%~%" (py:str agg))))

  (format t "[3] Filtering & Sorting~%")
  (let* ((data (py:call array (py:->python '((25 75000 0) (30 82000 1) (28 68000 0)
                                             (35 95000 1) (22 62000 2) (27 78000 2)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary" "dept")))
    (let* ((high-salary (py:call (py:attr df "__getitem__")
                                 (py:call (py:attr (py:attr df "salary") "ge")
                                          (py:->python 75000)))))
      (format t "  salary >= 75000:~%~A~%~%" (py:str high-salary))))

  (format t "[4] Joining DataFrames~%")
  (let* ((emp-data (py:call array (py:->python '((1 "Alice" 0) (2 "Bob" 1) (3 "Carol" 2)))))
         (dept-data (py:call array (py:->python '((0 "Engineering") (1 "Marketing") (2 "Sales")))))
         (emp (py:call (py:attr pd "DataFrame") emp-data))
         (dept (py:call (py:attr pd "DataFrame") dept-data)))
    (py:%set-attr emp "columns" (py:->python '("id" "name" "dept_id")))
    (py:%set-attr dept "columns" (py:->python '("dept_id" "dept_name")))
    (let ((joined (py:call (py:attr emp "merge") dept)))
      (format t "  JOIN (auto on dept_id):~%~A~%~%" (py:str joined))))

  (format t "=== Pandas Pipeline Complete ===~%~%"))
