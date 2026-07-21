;; Find All Duplicates (LC #442) - Python Counter
(defun find-duplicates (nums)
  (let* ((Counter (py:attr (py:import "collections") "Counter"))
         (cnt-ht (py:call Counter (py:->python nums)))
         (res nil))
    (loop for k being the hash-keys of cnt-ht using (hash-value v)
          do (when (= v 2) (push k res)))
    (nreverse res)))

(format t "Find All Duplicates:~%")
(format t "  [4,3,2,7,8,2,3,1] => ~A~%" (find-duplicates '(4 3 2 7 8 2 3 1)))
