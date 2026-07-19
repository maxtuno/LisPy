(py:run "import sympy as sp
m1,m2,l1,l2,g = sp.symbols('m1 m2 l1 l2 g', positive=True)
t1,t2 = sp.symbols('theta1 theta2')
dt1,dt2 = sp.symbols('dtheta1 dtheta2')
x1 = l1*sp.sin(t1); y1 = -l1*sp.cos(t1)
x2 = x1 + l2*sp.sin(t1+t2); y2 = y1 - l2*sp.cos(t1+t2)")
