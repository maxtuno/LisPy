;; CL-81: Symbols and packages demonstration
(defun symbol-demo ()
  (let ((sym 'hello)
        (sym2 (intern "DYNAMIC-SYMBOL"))
        (keyword :some-keyword))
    (format t "Symbol: ~A~%" sym)
    (format t "Symbol name: ~S~%" (symbol-name sym))
    (format t "Is keyword?: ~A~%" (keywordp keyword))
    (format t "Package of sym: ~S~%" (symbol-package sym))
    (format t "Dynamic symbol: ~A~%" sym2)
    (format t "Symbol function: ~A~%" (fboundp sym))
    (format t "is + symbol? ~A~%" (symbolp '+))))

(symbol-demo)
