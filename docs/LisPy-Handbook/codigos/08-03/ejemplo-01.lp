(py:run "from PIL import Image; import numpy as np
def load_image(path): return np.array(Image.open(path))
def save_image(arr, path): Image.fromarray(arr).save(path)")
