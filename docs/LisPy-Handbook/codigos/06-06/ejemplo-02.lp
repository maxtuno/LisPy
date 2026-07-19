(py:run "import matplotlib.pyplot as plt; import numpy as np
X, Y = np.meshgrid(np.linspace(-5,5,50), np.linspace(-5,5,50))
Z = np.sin(np.sqrt(X**2 + Y**2))
fig = plt.figure(); ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(X, Y, Z, cmap='viridis'); plt.savefig('surface.png')")
