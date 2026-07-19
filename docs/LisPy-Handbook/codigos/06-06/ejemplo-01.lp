(py:run "import matplotlib.pyplot as plt; import numpy as np
xs = np.linspace(0, 2*np.pi, 100); ys = np.sin(xs)
plt.plot(xs, ys); plt.title('sin(x)'); plt.savefig('sin.png')")
