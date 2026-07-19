;; CL-07: List basics - cons, car, cdr
(defun list-basics ()
  (let ((my-list (cons 1 (cons 2 (cons 3 nil)))))
    (format t "List: ~A~%" my-list)
    (format t "car:  ~D~%" (car my-list))
    (format t "cdr:  ~A~%" (cdr my-list))
    (format t "cadr: ~D~%" (cadr my-list))
    (format t "caddr: ~D~%" (caddr my-list))))

(list-basics)
