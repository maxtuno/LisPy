(py:run "import sympy as sp; x = sp.Symbol('x')
print(sp.series(sp.sin(x), x, 0, 7))")
