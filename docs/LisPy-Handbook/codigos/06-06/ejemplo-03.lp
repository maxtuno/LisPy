(py:run "import matplotlib.pyplot as plt; import matplotlib.animation as anim
import numpy as np
fig, ax = plt.subplots(); xs = np.linspace(0, 2*np.pi, 100)
line, = ax.plot(xs, np.sin(xs))
def animate(i): line.set_ydata(np.sin(xs + i/10)); return line,
ani = anim.FuncAnimation(fig, animate, interval=50)
ani.save('anim.gif', writer='pillow')")
