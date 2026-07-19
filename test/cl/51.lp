;; CL-51: Simple structure definition
(defstruct point
  (x 0)
  (y 0))

(defun point-operations ()
  (let ((p1 (make-point :x 3 :y 4))
        (p2 (make-point :x 7 :y 1)))
    (format t "p1 = (~D, ~D)~%" (point-x p1) (point-y p1))
    (format t "p2 = (~D, ~D)~%" (point-x p2) (point-y p2))
    (format t "Distance between p1 and p2 = ~F~%"
            (sqrt (+ (expt (- (point-x p1) (point-x p2)) 2)
                     (expt (- (point-y p1) (point-y p2)) 2))))
    
    (let ((mid (make-point :x (/ (+ (point-x p1) (point-x p2)) 2)
                           :y (/ (+ (point-y p1) (point-y p2)) 2))))
      (format t "Midpoint = (~D, ~D)~%" (point-x mid) (point-y mid)))))

(point-operations)
