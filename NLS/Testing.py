from pycm import ConfusionMatrix
import numpy as np
import pandas as pd
from sklearn.metrics import roc_curve, auc
from plotnine import *

test = pd.DataFrame(dict(Actual=y_actu, Predicted=y_pred))


y_actu = [2, 0, 2, 2, 0, 1, 1, 2, 2, 0, 1, 2]
y_pred = [2, 0, 2, 2, 0, 1, 1, 2, 2, 0, 1, 2]
cm = ConfusionMatrix(actual_vector=np.array(y_test), predict_vector=np.array(RF_preds))
print(cm)

p = (ggplot(test, aes(x="Actual", y="Predicted")) + geom_point())
print(p)