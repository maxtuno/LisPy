(load "lib/pandas-bridge.lp")
(defvar *df* (pandas-read-csv "datos.csv"))
(defvar *df2* (pandas-dataframe '((1 "A" 30) (2 "B" 25))
                :columns '("ID" "Nombre" "Edad")))
