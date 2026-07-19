(py:run "def image_pipeline(path):
    img = np.array(Image.open(path))
    yield 'original', img.copy()
    yield 'blurred', blur(img, 3)
    yield 'edges', sobel_edge(img)")
