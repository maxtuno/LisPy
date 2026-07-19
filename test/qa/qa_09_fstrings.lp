;; QA-09: @var in f-strings with complex expressions

(defun add (a b) (+ a b))
(defvar *a* 10)
(defvar *b* 20)

;; --- Multiple @vars in f-string ---
msg = f"{@*a*} + {@*b*} = {add(@*a*, @*b*)}"
(print @msg)

;; --- @var with arithmetic in f-string ---
total = f"Total: {@*a* + @*b*}"
(print @total)
