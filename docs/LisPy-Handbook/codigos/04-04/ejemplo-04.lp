(let ((x (numpy-linspace 0 (* 2 pi) 1000))
      (y (numpy-sin x)))
  (numpy-sum y))
