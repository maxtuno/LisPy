(py:run "import numpy as np; import matplotlib.pyplot as plt
fs = 1000; t = np.linspace(0, 1, fs)
senal = np.sin(2*np.pi*50*t) + np.sin(2*np.pi*120*t)
fft = np.fft.fft(senal); freqs = np.fft.fftfreq(len(senal), 1/fs)
plt.plot(freqs[:len(freqs)//2], np.abs(fft)[:len(fft)//2]); plt.savefig('fft.png')")
