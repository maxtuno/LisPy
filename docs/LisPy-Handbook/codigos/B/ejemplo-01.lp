;; Capturar error específico
(handler-case
    (expresión-peligrosa)
  (division-by-zero (c) ...)
  (error (c) ...))

;; Capturar sin desenrollar
(handler-bind
    ((condition-type #'handler-fn))
  ...)

;; Ignorar errores
(ignore-errors expresión)

;; Limpieza garantizada
(unwind-protect cuerpo limpieza)
