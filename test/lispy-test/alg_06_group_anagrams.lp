(defun sort-string (s)
  (coerce (sort (coerce s 'list) #'char<) 'string))

(defun group-anagrams (strs)
  (let ((groups (make-hash-table :test 'equal))
        (result nil))
    (dotimes (i (length strs))
      (let* ((s (elt strs i))
             (key (sort-string s))
             (bucket (gethash key groups)))
        (if bucket
            (setf (gethash key groups) (append bucket (list s)))
            (setf (gethash key groups) (list s)))))
    (loop for v being the hash-values of groups
          do (push v result))
    result))

(print (group-anagrams #("eat" "tea" "tan" "ate" "nat" "bat")))
