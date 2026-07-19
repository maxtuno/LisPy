;; CL-57: Vector operations
(defun vector-dot (v1 v2)
  (loop for a across v1
        for b across v2
        sum (* a b)))

(defun vector-magnitude (v)
  (sqrt (loop for x across v sum (* x x))))

(defun vector-normalize (v)
  (let ((mag (vector-magnitude v)))
    (if (zerop mag)
        v
        (map 'vector (lambda (x) (/ x mag)) v))))

(let ((v1 #(3 4 0))
      (v2 #(1 2 2)))
  (format t "v1 = ~A~%" v1)
  (format t "v2 = ~A~%" v2)
  (format t "Dot product: ~D~%" (vector-dot v1 v2))
  (format t "|v1| = ~,4F~%" (vector-magnitude v1))
  (format t "|v2| = ~,4F~%" (vector-magnitude v2))
  (format t "Normalized v2: ~A~%" (vector-normalize v2)))
