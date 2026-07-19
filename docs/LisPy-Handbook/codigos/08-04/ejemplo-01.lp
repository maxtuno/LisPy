(defvar *respuestas*
  '((:saludo "\( ¡ \)Hola! \( ¿ \)C\( ó \)mo est\( á \)s?")
    (:nombre "Me llamo LisPyBot")
    (:ayuda "Di: saludo, nombre, tiempo, ayuda, despedida")
    (:despedida "\( ¡ \)Hasta luego!")))

(defun responder (intencion)
  (let ((pair (assoc intencion *respuestas*)))
    (if pair (cadr pair) "No entiendo. Di 'ayuda'")))
