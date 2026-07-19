;; CL-19: Association lists (alists)
(defun alist-demo ()
  (let ((phonebook '((john . "555-0101")
                     (mary . "555-0102")
                     (bob  . "555-0103"))))
    (format t "Phonebook: ~A~%" phonebook)
    (format t "John's phone: ~A~%" (cdr (assoc 'john phonebook)))
    (format t "Mary's phone: ~A~%" (cdr (assoc 'mary phonebook)))
    
    (let ((updated (acons 'alice "555-0104" phonebook)))
      (format t "After adding Alice: ~A~%" updated)
      (format t "Alice's phone: ~A~%" (cdr (assoc 'alice updated))))))

(alist-demo)
