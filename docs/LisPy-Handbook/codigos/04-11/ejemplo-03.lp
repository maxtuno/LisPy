(pandas-filter *df* (lambda (row) (> (py:getitem row "Edad") 25)))
(pandas-groupby *df* "Categoria" :aggregations '(("Ventas" . "sum")))
