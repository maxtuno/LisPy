(py:run "from scipy import ndimage; import numpy as np
def blur(img, sigma=2): return ndimage.gaussian_filter(img, sigma=(sigma,sigma,0))
def sobel_edge(img):
    gray = np.mean(img, axis=2) if len(img.shape) == 3 else img
    return np.abs(ndimage.sobel(gray)).astype(np.uint8)")
