(maphash (lambda (k v) (format t "~A → ~A~%" k v)) *ht*)
(hash-table-count *ht*)
(hash-table-p *ht*)
