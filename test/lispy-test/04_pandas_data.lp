;;; ============================================================
;;; LisPy Advanced 04 — Pandas: Data Analysis
;;; Pure py: API — DataFrames, column ops
;;; ============================================================

(format t "~%=== LisPy + Pandas: Data Analysis ===~%~%")

(let* ((np (py:import "numpy"))
       (pd (py:import "pandas"))
       (array (py:attr np "array")))

  (format t "[1] DataFrame from NumPy array~%")
  (let* ((data (py:call array (py:->python '((25.0 75000.0) (30.0 82000.0) (28.0 68000.0)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary")))
    (format t "~A~%~%" (py:str df)))

  (format t "[2] Column Operations~%")
  (let* ((data (py:call array (py:->python '((25.0 75000.0) (30.0 82000.0) (28.0 68000.0)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary")))
    (let* ((to-float (py:attr (py:import "builtins") "float"))
           (ages (py:attr df "age"))
           (salaries (py:attr df "salary"))
           (age-mean (py:call to-float (py:call (py:attr ages "mean"))))
           (salary-mean (py:call to-float (py:call (py:attr salaries "mean"))))
           (salary-max (py:call to-float (py:call (py:attr salaries "max")))))
      (format t "  Mean age:     ~A~%" age-mean)
      (format t "  Mean salary:  ~A~%" salary-mean)
      (format t "  Max salary:   ~A~%~%" salary-max)))

  (format t "[3] Filtering~%")
  (let* ((data (py:call array (py:->python '((25.0 75000.0) (30.0 82000.0) (28.0 68000.0)))))
         (df (py:call (py:attr pd "DataFrame") data)))
    (py:%set-attr df "columns" (py:->python '("age" "salary")))
    (let* ((high-salary (py:call (py:attr df "__getitem__")
                                 (py:call (py:attr (py:attr df "salary") "ge")
                                          (py:->python 75000.0)))))
      (format t "  Rows with salary >= 75000:~%~A~%~%" (py:str high-salary))))

  (format t "=== Pandas Demo Complete ===~%~%"))
