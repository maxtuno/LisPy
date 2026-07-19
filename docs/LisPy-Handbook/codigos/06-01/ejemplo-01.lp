(load "lib/defmath.lp")
(defmath f (x) (sin (* 2 x)))

;; Derivar
(let ((df (sympy-derive (f-sym 'x) 'x))) (sympy-latex df))

;; Evaluar
(let ((xs (numpy-linspace 0 (* 2 pi) 1000))) (f-num xs))

;; Visualizar (vía matplotlib)
(py:run "import matplotlib.pyplot as plt; import numpy as np
xs = np.linspace(0, 2*np.pi, 1000)
plt.plot(xs, np.sin(2*xs)); plt.savefig('sin2x.png')")
