(load "lib/ffi.lp")

;; Linux: libm tiene sqrt, sin, cos, pow
(ffi:with-ffi "libm.so.6"
  (c-sqrt :double (:double) "sqrt")
  (c-sin  :double (:double) "sin")
  (c-cos  :double (:double) "cos")
  (c-pow  :double (:double :double) "pow"))

;; libc tiene abs
(ffi:with-ffi "libc.so.6"
  (c-abs  :int (:int) "abs"))

(print (c-sqrt 64.0))
(print (c-sin 1.57))
(print (c-cos 0.0))
(print (c-pow 2.0 10.0))
(print (c-abs -42))
