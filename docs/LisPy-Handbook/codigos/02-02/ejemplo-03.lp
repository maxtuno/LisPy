(defpackage :mi-paquete (:use :common-lisp) (:export :funcion-exportada))
(in-package :mi-paquete)
(defun funcion-exportada () "visible fuera")
