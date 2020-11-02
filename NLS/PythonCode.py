"""
Goal: Predict High School Graduation
Author: Matt Quinn
Date: 29th October 2020
Sources:
    https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html
    https://towardsdatascience.com/decision-tree-fundamentals-388f57a60d2a
    https://stackoverflow.com/questions/37647396/statsmodels-logistic-regression-odds-ratio
    https://stackoverflow.com/questions/13413590/how-to-drop-rows-of-pandas-dataframe-whose-value-in-a-certain-column-is-nan

"""

###############################################################################
###                     1.  Define Working Directory                        ###
###############################################################################
import os
abspath = os.path.abspath("C:/Users/miqui/OneDrive/CSU Classes/Consulting/NLS")
os.chdir(abspath)
os.listdir()
###############################################################################
###                    2. Import Libraries and Data                       ###
###############################################################################
# Machine learning stuff
import pandas as pd
import numpy as np
import plotly.express as px
import plotly
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer


# Deep learning stuff
import tensorflow as tf
print(tf.__version__)
tf.config.experimental.list_physical_devices()
from tensorflow import keras
from tensorflow.keras.models import Sequential
import tensorflow_addons as tfa
import tensorflow.keras.metrics as metrics
from tensorflow.keras.layers.experimental import preprocessing

pd.set_option('display.max_columns', 10)
pd.set_option('display.max_rows', 200)

# Import the cleaned dataset from R:
df = pd.read_csv("NEWMallett.csv", header=0)


###############################################################################
###                      4. Exploratory Data Analysis                       ###
###############################################################################
"Let's start with some frequency tables:"

df.dtypes

Categorical = list(df.select_dtypes(include=['object', 'category']).columns)

for name in Categorical:
    print(name, ":")
    print(df[name].value_counts(), "\n")

"Replace I, V, D, R values with np.nan"
df.replace(to_replace=["I", "V", "D", "R"], value=np.nan, inplace=True)
df.replace(to_replace=[np.inf, -np.inf], value=np.nan, inplace=True)

"Convert various categorical variables to numeric"
numeric = ["number_grades_repeated", "number_grades_skipped", "highest_degree", "SAT_math_score_2007",
           "SAT_verbal_score_2007", "ACT_score_2007", "number_schools_attended", "parent_expectation_in_jail_by20",
           "age_first_incarcerated", "debts_20", "debts_25", "debts_30", "debts_35", "total_n_incarcerated",
           "months_longest_incarceration", "months_first_incarceration", "number_jobs_since20"]

df[numeric] = df[numeric].astype(float, errors="ignore")

"Replace I, V, D, R values with np.nan"
Categorical = list(df.select_dtypes(include=['object', 'category']).columns)

for name in Categorical:
    print(name, ":")
    print(df[name].unique(), "\n")

###############################################################################
###                     7. Train-Test Split                                 ###
###############################################################################

"Define X and Y variables"
df.columns

# Take rows where hs_grad is not NA:
df = df[df["hs_grad"].notna()]

# Replace Class with your response variable
y = df["hs_grad"]
predictors = ["immigrant", "days_ms_suspension", "black", "NumSchoolsAttended",
              "female", "VictViolentCrime", "Homeless", "HHHospital", "HHJail",
              "ever_in_gang"]  # Add as needed
x = df[predictors]  # Drop any unneeded variables

x_train, x_test, y_train, y_test = train_test_split(
    x, y,
    test_size=0.20,  # 80/20 split
    random_state=123,  # Set a random seed for reproducibility
    shuffle=True)



def Impute(df):
    names = df.columns
    imputer = IterativeImputer(max_iter=10, random_state=123)
    clean_df = imputer.fit_transform(X=df)
    clean_df = pd.DataFrame(clean_df)
    clean_df.columns = names
    return clean_df


x_train1 = Impute(x_train)
x_test = Impute(x_test)
###############################################################################
###                      9. Running Our Models                              ###
###############################################################################
import statsmodels.api as sm
from sklearn.ensemble import RandomForestClassifier
from sklearn import tree

"Logistic Regression Model:"
predictors = ["immigrant", "days_ms_suspension", "black", "NumSchoolsAttended"]  # Add as needed
x = df[predictors]
exog = sm.add_constant(x)

log_reg = sm.Logit(endog=y, exog=exog.astype(float),
                   missing="drop").fit()
print(log_reg.summary())

# Get the odds ratios for each of the parameters:
np.exp(log_reg.params)
###############################################################################
###                      10. Hyper-parameter Tuning for RF                   ###
###############################################################################
help(RandomForestClassifier)

BestModel = RandomForestClassifier(criterion="gini",  # Use gini impurity to measure
                                   max_features="auto",  # Default value (sqrt(n_features))
                                   min_samples_split=3,  # the min. number of samples to split an internal node
                                   max_depth=3,
                                   oob_score=True,  # use the out-of-bag samples to generalize the accuracy?
                                   verbose=1,
                                   warm_start=True)  # reuse the previous fit and add more estimators to it
# Run the model:
BestModel.fit(X=x_train1, y=y_train)

# Check what's available with our newest model:
dir(BestModel)

RF_preds = BestModel.predict(X=x_test)
RF_probs = BestModel.predict_proba(X=x_test)

###############################################################################
###                      11. Feature Importances                            ###
###############################################################################


def imp_df(column_names, importances):
    df = pd.DataFrame({'feature': column_names,
                       'feature_importance': importances}) \
        .sort_values('feature_importance', ascending=False) \
        .reset_index(drop=True)
    return df


Importances = imp_df(x_train1.columns, BestModel.feature_importances_)

Importances

def var_imp_plot(Importances, Title):
    Importances.columns = ["Variable", "Gini Index"]
    fig = px.bar(Importances, x="Gini Index", y="Variable", color="Variable", title=Title)
    plotly.offline.plot(fig, auto_open=True, filename="test.html")


var_imp_plot(Importances, Title="Variable Importance")

# Plot one of the decision trees:
fig = plt.figure(figsize=(15, 12.5))
_ = tree.plot_tree(BestModel.estimators_[99],
                   feature_names=x_train1.columns,
                   class_names=["Graduate", "Non-graduate"],
                   filled=True)

###############################################################################
###                      12. Model Validation                               ###
###############################################################################
BestModel.score(x_test, y_test)  # Test the mean accuracy on unseen data
# 78.87% mean accuracy
###############################################################################
###                      14. Deep Learning                                  ###
###############################################################################

"""When the network is small relative to the dataset, regularization is usually unnecessary.
If the model capacity is already low, lowering it further by adding regularization will hurt performance.
I noticed most of your networks were relatively small and shallow."""

"""
BATCH NORMALIZATION:
    Apparently, batch normalization just computes a Z-score:" \
        Given by this information: https://www.tensorflow.org/api_docs/python/tf/keras/layers/BatchNormalization
    We will normalize each scalar feature independently, by making it have the mean of 0 and the variance of 1
    Uses population statistics, not mini-batch
    Apparently gets to convergence with fewer epochs?
"""

"""
Adadelta optimization is a stochastic gradient descent method that is based on
  adaptive learning rate per dimension to address two drawbacks:

  - The continual decay of learning rates throughout training
  - The need for a manually selected global learning rate
"""
df = df[df["hs_grad"].notna()]

# Replace Class with your response variable
y = df["hs_grad"]
predictors = ["immigrant", "days_ms_suspension", "black", "urban1997", "days_hs_suspension",
              "NumSchoolsAttended", "female", "age", "white", "hispanic"]  # Add as needed
x = df[predictors]  # Drop any unneeded variables

x_train, x_test, y_train, y_test = train_test_split(
    x, y,
    test_size=0.20,  # 80/20 split
    random_state=123,  # Set a random seed for reproducibility
    shuffle=True)


# Add an experimental pre-processing layer:
normalizer = preprocessing.Normalization()
normalizer.adapt(np.array(x_train))

# Add a callback to run during training:
# If the loss doesn't improve after 3 epochs, stop.
callback = tf.keras.callbacks.EarlyStopping(monitor="loss", patience=3)

################################
# Build your DNN:
# Fully connected since each layer feeds the next layer
model = Sequential(name="DNN")
model.add(normalizer)
model.add(layer=keras.layers.Dense(64, activation="relu", name="layer1"))
model.add(layer=keras.layers.BatchNormalization(axis=1, center=True, scale=True, name="BatchNorm"))
model.add(layer=keras.layers.Dense(32, activation="relu", name="layer2"))
model.add(layer=keras.layers.Dropout(rate=0.2))
model.add(layer=keras.layers.Dense(16, activation="relu", name="layer3"))
model.add(layer=keras.layers.Dense(1, activation="sigmoid", name="OutputLayer"))

model.compile(loss=tf.keras.losses.BinaryCrossentropy(from_logits=True),  # more numerically stable
              optimizer=tf.keras.optimizers.Adam(learning_rate=0.01),  # The famous Adam optimizer
              metrics=["accuracy"])

model.build(input_shape=[7172, 10])

# Get a snapshot of the model built:
model.summary()  # DON'T SKIP ME!!!!

# Train the model:
history = model.fit(
                x=np.array(x_train), y=np.array(y_train),
                validation_split=0.2,  # 80/20 split
                verbose=1,
                epochs=50,  # Notice that r-square is pretty low for the first 5 epochs
                callbacks=[callback])  # Early stopping

tf_preds = model.predict(x=x_test)


dir(history)

# summarize history for R^2:
plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('Model Accuracy over Epochs')
plt.ylabel('Accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()

#############################################################
#                      Model Performance                    #
#############################################################
from pycm import ConfusionMatrix

# Yes, both Sci-kit learn and PYCM give the same confusion matrix, thankfully.

cm = ConfusionMatrix(actual_vector=np.array(y_test), predict_vector=np.array(RF_preds))
print(cm)

# Plotting the ROC_AUC Curve:
skplot.metrics.plot_roc(y_test, probs_multi)
plt.show()
