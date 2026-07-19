(load "lib/ffi.lp")

(ffi:with-ffi "msvcrt.dll"
  (c-sqrt :double (:double) "sqrt")
  (c-sin  :double (:double) "sin")
  (c-cos  :double (:double) "cos")
  (c-pow  :double (:double :double) "pow")
  (c-abs  :int (:int) "abs"))

(print (c-sqrt 64.0))
(print (c-sin 1.57))
(print (c-cos 0.0))
(print (c-pow 2.0 10.0))
(print (c-abs -42))
