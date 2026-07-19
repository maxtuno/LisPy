;; CL-48: Number theory - prime checker
(defun prime-p (n)
  (cond ((< n 2) nil)
        ((= n 2) t)
        ((evenp n) nil)
        (t (loop for i from 3 to (isqrt n) by 2
                 never (zerop (mod n i))))))

(defun primes-up-to (limit)
  (loop for i from 2 to limit
        when (prime-p i)
        collect i))

(format t "Is 17 prime? ~A~%" (prime-p 17))
(format t "Is 91 prime? ~A~%" (prime-p 91))
(format t "Is 97 prime? ~A~%" (prime-p 97))
(format t "~%Primes up to 50: ~A~%" (primes-up-to 50))
(format t "Count of primes up to 100: ~D~%" (length (primes-up-to 100)))
