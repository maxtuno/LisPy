(defun search (query index &key (top-k 5))
  (let* ((words (split-string query))
         (scores (make-hash-table :test 'eql)))
    (dolist (word words)
      (dolist (doc-id (gethash word index))
        (incf (gethash doc-id scores 0))))
    (sort (loop for k being the hash-keys of scores
                collect (list k (gethash k scores)))
          #'> :key #'second :end top-k)))
