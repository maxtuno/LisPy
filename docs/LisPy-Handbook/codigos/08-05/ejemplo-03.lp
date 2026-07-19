(defvar *docs* '((1 "machine learning") (2 "deep learning") (3 "python ml")))
(defvar *index* (build-index *docs*))
(search "learning" *index*)
