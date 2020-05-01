from doepy import build


levels = {"Pressure": [40, 55, 70],
          "Temperature": [290, 320, 350],
          "Flow-rate": [0.2, 0.4],
          "Time": [5, 8]}
levels

# Number of entries = 3*3*2*2 = 36 entries for 1 replicate
full_factorial = build.build_full_fact(levels)

# Check for 36 entries
len(full_factorial) # 36









import timeit
from sklearn.decomposition import PCA
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import fetch_olivetti_faces
olive = fetch_olivetti_faces()
dir(olive)

X,y = olive.data, olive.target
pca = PCA(n_components=64)
X_trans = pca.fit_transform(X)
print(X_trans.shape)

# Create time function for RF model:

def ModelTime(X, y):
    start = timeit.default_timer()
    RandomForestClassifier().fit(X=X, y=y)
    stop = timeit.default_timer()
    print(f"Time {stop - start}")

# Model 1 - Original data set

ModelTime(X=X, y=y)

# Model 2 - PCA data set

ModelTime(X=X_trans, y=y)