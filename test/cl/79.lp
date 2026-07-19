;; CL-79: Function tracing / advice-like pattern
(defun instrumented-add (a b)
  (format t "[TRACE] instrumented-add called with ~D and ~D~%" a b)
  (let ((result (+ a b)))
    (format t "[TRACE] returning ~D~%" result)
    result))

(defun traced-factorial (n)
  (format t "[TRACE] factorial(~D) called~%" n)
  (if (<= n 1)
      (progn
        (format t "[TRACE] factorial(~D) => 1 (base case)~%" n)
        1)
      (let* ((sub (traced-factorial (- n 1)))
             (result (* n sub)))
        (format t "[TRACE] factorial(~D) = ~D * ~D = ~D~%" n n sub result)
        result)))

(format t "Traced addition:~%")
(format t "  Result: ~D~%" (instrumented-add 5 7))
(format t "~%Traced factorial:~%")
(format t "  factorial(5) = ~D~%" (traced-factorial 5))
