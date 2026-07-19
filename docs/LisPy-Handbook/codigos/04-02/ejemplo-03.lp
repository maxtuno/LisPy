(let ((result (pythonic
                (def euler-1 (n)
                  (:= total 0)
                  (for i in (range n)
                    (if (or (== (% i 3) 0) (== (% i 5) 0))
                      (:= total (+ total i))))
                  (return total)))))
  (funcall result 1000))
