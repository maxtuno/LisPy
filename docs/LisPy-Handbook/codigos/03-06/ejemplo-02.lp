(let* ((frames (py:last-traceback))
       (frame (elt frames 0)))
  (py:frame-locals frame)     ;; → hash-table
  (py:frame-globals frame)    ;; → hash-table
  (py:frame-eval "x + y" frame))  ;; evalúa en contexto
