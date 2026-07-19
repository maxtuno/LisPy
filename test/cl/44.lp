;; CL-44: rotatef and psetf
(defun swap-demo ()
  (let ((a 10) (b 20))
    (format t "Before rotatef: a = ~D, b = ~D~%" a b)
    (rotatef a b)
    (format t "After rotatef:  a = ~D, b = ~D~%" a b))
  
  (let ((x 1) (y 2) (z 3))
    (format t "~%Before psetf: x = ~D, y = ~D, z = ~D~%" x y z)
    (psetf x y y z z x)
    (format t "After psetf:  x = ~D, y = ~D, z = ~D~%" x y z)))

(swap-demo)
