(defvar *buf* (make-array 3 :fill-pointer 0 :initial-element nil))
(vector-push 'a *buf*)
(vector-pop *buf*)
