;; CL-90: Roman numeral conversion
(defun integer-to-roman (n)
  (let* ((values  '(1000 900 500 400 100 90 50 40 10 9 5 4 1))
         (symbols '("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I"))
         (result "")
         (remaining n))
    (loop for v in values
          for s in symbols do
      (loop while (>= remaining v) do
        (setf result (concatenate 'string result s))
        (setf remaining (- remaining v))))
    result))

(defun roman-to-integer (s)
  (let ((map (make-hash-table :test #'equal))
        (total 0)
        (prev 0))
    (setf (gethash "I" map) 1)
    (setf (gethash "V" map) 5)
    (setf (gethash "X" map) 10)
    (setf (gethash "L" map) 50)
    (setf (gethash "C" map) 100)
    (setf (gethash "D" map) 500)
    (setf (gethash "M" map) 1000)
    (loop for i from (- (length s) 1) downto 0 do
      (let* ((ch (subseq s i (+ i 1)))
             (val (gethash ch map 0)))
        (if (< val prev)
            (decf total val)
            (incf total val))
        (setf prev val)))
    total))

(format t "Integer to Roman numeral conversion:~%")
(loop for n in '(1 4 9 49 58 1994 2024 3999) do
  (let ((roman (integer-to-roman n)))
    (format t "  ~4D => ~8A" n roman)
    (format t "  |  ~A => ~D~%" roman (roman-to-integer roman))))
