(py:run "from scipy import signal as sig; import numpy as np
b, a = sig.butter(4, 0.1, 'low'); t = np.linspace(0, 1, 1000)
clean = np.sin(2*np.pi*10*t); noisy = clean + 0.5*np.random.randn(len(t))
filtered = sig.filtfilt(b, a, noisy)")
