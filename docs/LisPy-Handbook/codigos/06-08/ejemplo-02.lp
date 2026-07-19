(py:run "from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA; from sklearn.svm import SVC
from sklearn.datasets import load_digits
digits = load_digits()
X_train, X_test, y_train, y_test = train_test_split(
    digits.data, digits.target, test_size=0.2)
pipeline = Pipeline([('scaler', StandardScaler()),
                     ('pca', PCA(n_components=30)),
                     ('svc', SVC(kernel='rbf'))])
pipeline.fit(X_train, X_test); print(pipeline.score(X_test, y_test))")
