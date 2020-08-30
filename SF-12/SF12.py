"""
Title: Step One of Scoring the SF-12 version 2
Author: Matt Quinn
Date: 25th August 2020
End: 27th August 2020
Class: STA 635
Resources:
    https://www.geeksforgeeks.org/using-dictionary-to-remap-values-in-pandas-dataframe-columns/

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
import dfply

"Increasing the Max Columns to Display: "
pd.set_option('display.max_columns', 20)

"Read in the sample data set from Excel: "
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

ReverseVars = ["Y8", "Y9", "Y10"]

nomiss[ReverseVars] = nomiss[ReverseVars].applymap(lambda x: 6-x)

# Check our results:
nomiss[ReverseVars].head()

"Computing the Mean and Standard Deviation of Each Column: "
meanStdDev = nomiss.describe()
print(meanStdDev)

"Recalibrating Item # 1 via a Dictionary: "
Item1Dict = {np.nan: np.nan, 1: 5, 2: 4.4, 3: 3.4, 4: 2, 5: 1}

# Map the new values from the old values
nomiss["Y1"] = nomiss["Y1"].map(Item1Dict)

####################################################################
#              Step 4: Compute the Raw Scale Scores                #
####################################################################
Items = pd.DataFrame() # start with an empty dataframe

"Compute the Raw Scores: "
Items["PF"] = nomiss["Y2"] + nomiss["Y3"]
Items["RP"] = nomiss["Y4"] + nomiss["Y5"]
Items["BP"] = nomiss["Y8"]
Items["GH"] = nomiss["Y1"]
Items["VT"] = nomiss["Y10"]
Items["SF"] = nomiss["Y12"]
Items["RE"] = nomiss["Y6"] + nomiss["Y7"]
Items["MH"] = nomiss["Y9"] + nomiss["Y11"]

####################################################################
#            Step 5: Compute the Transformed Scores                #
####################################################################
"Ranges:"
"""
PF = [2-6]
RP = [2-10]
BP = [1-5]
GH = [1-5]
VT = [1-5]
SF = [1-5]
RE = [2-10]
MH = [2-10]

Compute the transformed score via this formula:
Transformed Scale = (((Actual Score - Min. Possible Score)/Possible Raw Score Range)*100)
"""

Items["TransPF"] = ((Items["PF"]-2)/4)*100
Items["TransRP"] = ((Items["RP"]-2)/8)*100
Items["TransBP"] = ((Items["BP"]-1)/4)*100
Items["TransGH"] = ((Items["GH"]-1)/4)*100
Items["TransVT"] = ((Items["VT"]-1)/4)*100
Items["TransSF"] = ((Items["SF"]-1)/4)*100
Items["TransRE"] = ((Items["RE"]-2)/8)*100
Items["TransMH"] = ((Items["MH"]-2)/8)*100

####################################################################
#                 Step 6: Compute the Z-Scores                     #
####################################################################
"""
First Step = standardizing each SF-12v2 scale using a Z-score transformation" \
A Z-score is computed by subtracting the mean 0-100 score in the 1998 general U.S. pop.
for each SF-12v2 scale score and dividing the difference by the corresponding scale's Std. Dev.
"""

Items["PF_Z"] = (Items["TransPF"] - 81.18122)/29.10558
Items["RP_Z"] = (Items["TransRP"] - 80.52856)/27.13526
Items["BP_Z"] = (Items["TransBP"] - 81.74015)/24.53019
Items["GH_Z"] = (Items["TransGH"] - 72.19795)/23.19041
Items["VT_Z"] = (Items["TransVT"] - 55.59090)/24.84380
Items["SF_Z"] = (Items["TransSF"] - 83.73973)/24.75775
Items["RE_Z"] = (Items["TransRE"] - 86.41051)/22.35543
Items["MH_Z"] = (Items["TransMH"] - 70.18217)/20.50597

Zs = ["PF_Z", "RP_Z", "BP_Z", "GH_Z", "VT_Z", "SF_Z", "RE_Z", "MH_Z"]
Items[Zs].describe()
####################################################################
#                 Step 7: Aggregate Scale Scores                   #
####################################################################
"""
Create Aggregate-Scale Scores
"""
# Aggregate Physical Summary Score:
Items["PHYS"] = (Items["PF_Z"]*0.42402) + (Items["RP_Z"]*0.35119) + (Items["BP_Z"]*0.31754) + (Items["GH_Z"]*0.24954) + \
                (Items["VT_Z"]*0.02877) + (Items["SF_Z"]*-0.00753) + (Items["RE_Z"]*-0.19206) + (Items["MH_Z"]*-0.22069)

# Aggregate Mental Summary Score:
Items["MENT"] = (Items["PF_Z"]*-0.22999) + (Items["RP_Z"]*-0.12329) + (Items["BP_Z"]*-0.09731) + (Items["GH_Z"]*-0.01571) + \
                (Items["VT_Z"]*0.23534) + (Items["SF_Z"]*0.26876) + (Items["RE_Z"]*0.43407) + (Items["MH_Z"]*0.48581)

####################################################################
#                 Step 8: Aggregate T-Scores                       #
####################################################################
"Mean = 50 and SD = 10: "
Items["TransPHYS"] = 50 + (Items["PHYS"]*10)

Items["TransMENT"] = 50 + (Items["MENT"]*10)


"Results Summaries: "
Items.describe()
