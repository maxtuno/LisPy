;; CL-12: Recursive member function
(defun my-member (item lst)
  (cond ((null lst) nil)
        ((equal item (car lst)) lst)
        (t (my-member item (cdr lst)))))

(format t "Is 3 in (1 2 3 4)? ~A~%" (my-member 3 '(1 2 3 4)))
(format t "Is 5 in (1 2 3 4)? ~A~%" (my-member 5 '(1 2 3 4)))
(format t "Is 'b' in (a b c)? ~A~%" (my-member 'b '(a b c)))
