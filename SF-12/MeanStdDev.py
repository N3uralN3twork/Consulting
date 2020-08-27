"""
Title: Step One of Scoring the SF-12 version 2
Author: Matt Quinn
Date: 25th August 2020
Class: STA 635
Resources:

"""
####################################################################
#                Set the WD and Import the Libraries               #
####################################################################
"Setting the Working Directory: "
import os
os.chdir(path="C:/Users/miqui/OneDrive/CSU Classes/Consulting/SF-12")
os.listdir()

"Importing the Necessary Libraries: "
import pandas as pd
import numpy as np

"Increasing the Max Columns to Display: "
pd.set_option('display.max_columns', 20)

"Read in the sample data set: "
nomiss = pd.read_excel("SF12_nomissing.xlsx",
                     sheet_name="data")
nomiss.head(3)
nomiss.describe()

####################################################################
#            Step 1: Add 1 to all Columns Except Age               #
####################################################################
PlusOne = ['Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6', 'Y7', 'Y8', 'Y9', 'Y10', 'Y11', 'Y12']

nomiss[PlusOne] = nomiss[PlusOne]+1 # Faster version compared to .applymap()

nomiss.describe()

####################################################################
#           Step 2: Code Out-of-Range Values to NA                 #
####################################################################

nomiss.columns

"Ranges [1 - 3]:"
OnetoThreeColumns = ["Y2", "Y3"]

# Change out of range values to NA for questions with a range between 1 and 3:
nomiss[OnetoThreeColumns] = nomiss[OnetoThreeColumns].applymap(lambda x: np.where(x in range(1, 4), x, None))

"Ranges [1 - 5]:"
OnetoFiveColumns = ["Y1", "Y4", "Y5", "Y6", "Y7",
                    "Y8", "Y9", "Y10", "Y11", "Y12"]

# Change out of range values to NA for questions with a range between 1 and 5:
nomiss[OnetoFiveColumns] = nomiss[OnetoFiveColumns].applymap(lambda x: np.where(x in range(1, 6), x, None))

"Check our results: "
nomiss.describe()

####################################################################
#         Step 3: Reverse Code 4 Items to Higher Scale             #
####################################################################

"General Formula for reversing a scale = (N+1)-i:"

ReverseVars = ["Y1", "Y8", "Y9", "Y10"]

nomiss[ReverseVars] = nomiss[ReverseVars].applymap(lambda x: 6-x)

# Check our results:
nomiss[ReverseVars].head()

"Computing the Mean and Standard Deviation of Each Column: "
meanStdDev = nomiss.describe()
print(meanStdDev)

####################################################################
#              Step 4: Compute the Raw Scale Scores                #
####################################################################

