;; CL-87: Simple Conway's Game of Life
(defun make-grid (rows cols)
  (make-array (list rows cols) :initial-element 0))

(defun count-neighbors (grid row col)
  (let ((count 0)
        (rows (array-dimension grid 0))
        (cols (array-dimension grid 1)))
    (loop for dr from -1 to 1 do
      (loop for dc from -1 to 1 do
        (unless (and (= dr 0) (= dc 0))
          (let ((r (+ row dr))
                (c (+ col dc)))
            (when (and (>= r 0) (< r rows) (>= c 0) (< c cols))
              (incf count (aref grid r c)))))))
    count))

(defun next-gen (grid)
  (let* ((rows (array-dimension grid 0))
         (cols (array-dimension grid 1))
         (next (make-grid rows cols)))
    (loop for r from 0 below rows do
      (loop for c from 0 below cols do
        (let ((neighbors (count-neighbors grid r c)))
          (setf (aref next r c)
                (if (= 1 (aref grid r c))
                    (if (or (= neighbors 2) (= neighbors 3)) 1 0)
                    (if (= neighbors 3) 1 0))))))
    next))

(defun print-grid (grid)
  (let ((rows (array-dimension grid 0))
        (cols (array-dimension grid 1)))
    (loop for r from 0 below rows do
      (loop for c from 0 below cols do
        (format t "~C" (if (= 1 (aref grid r c)) #\# #\.)))
      (format t "~%"))
    (format t "~%")))

(let ((grid (make-grid 5 5)))
  ;; Glider pattern
  (setf (aref grid 1 2) 1)
  (setf (aref grid 2 3) 1)
  (setf (aref grid 3 1) 1)
  (setf (aref grid 3 2) 1)
  (setf (aref grid 3 3) 1)
  
  (format t "Generation 0:~%")
  (print-grid grid)
  
  (loop for gen from 1 to 3
        for g = grid then (next-gen g)
        do (format t "Generation ~D:~%" gen)
           (print-grid g)))
