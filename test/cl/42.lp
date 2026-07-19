;; CL-42: prog1, prog2, progn
(defun sequencing-demo ()
  (format t "progn: evaluate all, return last~%")
  (let ((result (progn
                  (format t "  First~%")
                  (format t "  Second~%")
                  (+ 1 2))))
    (format t "  Result: ~D~%" result))
  
  (format t "~%prog1: evaluate all, return first~%")
  (let ((result (prog1
                  (+ 10 20)
                  (format t "  This is second~%")
                  (format t "  This is third~%"))))
    (format t "  Result: ~D~%" result))
  
  (format t "~%prog2: evaluate all, return second~%")
  (let ((result (prog2
                  (format t "  First~%")
                  (* 3 4)
                  (format t "  Third~%"))))
    (format t "  Result: ~D~%" result)))

(sequencing-demo)
