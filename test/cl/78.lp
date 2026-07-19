;; CL-78: Basic combinatorics
(defun factorial* (n)
  (loop for i from 1 to n
        with result = 1
        do (setf result (* result i))
        finally (return result)))

(defun combinations (n k)
  (/ (factorial* n)
     (* (factorial* k) (factorial* (- n k)))))

(defun permutations (n k)
  (/ (factorial* n) (factorial* (- n k))))

(format t "Factorials:~%")
(loop for i from 0 to 8 do
  (format t "  ~D! = ~D~%" i (factorial* i)))

(format t "~%Combinations C(n,k) = n! / (k!(n-k)!)~%")
(loop for n from 1 to 5 do
  (format t "  C(~D,*) = " n)
  (loop for k from 0 to n do
    (format t "~D " (combinations n k)))
  (format t "~%"))

(format t "~%Permutations P(5,3) = ~D~%" (permutations 5 3))
