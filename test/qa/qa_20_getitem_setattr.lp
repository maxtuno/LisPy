;; Test: py:getitem, py:len, py:iter, py:next
(print "-- executing qa_20 --")

;; py:len on Python list
(let ((py-list (py:->python (list 1 2 3 4 5))))
  (assert (= 5 (py:len py-list))))

;; py:iter and py:next
(py:run "_lispy_iter = iter([10, 20, 30])")
(let* ((it (py:attr (py:import "__main__") "_lispy_iter"))
       (a (py:next it))
       (b (py:next it))
       (c (py:next it)))
  (assert (= 10 (py:->lisp a)))
  (assert (= 20 (py:->lisp b)))
  (assert (= 30 (py:->lisp c))))

;; py:getitem on Python list
(let ((py-list (py:->python (list 10 20 30 40 50))))
  (assert (= 10 (py:->lisp (py:getitem py-list 0))))
  (assert (= 30 (py:->lisp (py:getitem py-list 2))))
  (assert (= 50 (py:->lisp (py:getitem py-list 4)))))

(print "qa_20: OK")
