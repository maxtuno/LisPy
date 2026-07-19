(defmath lorentzian (x gamma) (/ 1 (+ 1 (expt (/ x gamma) 2))))
(sympy-derive (lorentzian-sym 'x 'gamma) 'x)
(let ((xs (numpy-linspace -10 10 1000))) (lorentzian-num xs 1.0))
