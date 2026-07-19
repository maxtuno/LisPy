;; CL-39: Hash tables
(defun hash-table-demo ()
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "apple" ht) 5)
    (setf (gethash "banana" ht) 3)
    (setf (gethash "cherry" ht) 7)
    
    (format t "Hash table contents:~%")
    (format t "  apple:  ~D~%" (gethash "apple" ht))
    (format t "  banana: ~D~%" (gethash "banana" ht))
    (format t "  cherry: ~D~%" (gethash "cherry" ht))
    (format t "  grape (default):  ~D~%" (gethash "grape" ht 0))
    
    (format t "~%Iterating hash table:~%")
    (maphash (lambda (k v) (format t "  ~A => ~D~%" k v)) ht)
    
    (format t "~%Count: ~D entries~%" (hash-table-count ht))))

(hash-table-demo)
