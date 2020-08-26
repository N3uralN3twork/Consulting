"""
Title: Step One of Scoring the SF-12
Author: Matt Quinn
Date: 25th August 2020
Class: STA 635
"""
####################################################################
###            Set the WD and Import the Libraries               ###
####################################################################
import os
os.chdir(path="C:/Users/miqui/OneDrive/Consulting/SF-12")
os.listdir()

import numpy as np
import pandas as pd

pd.set_option('display.max_columns', 10)

#Read in the sample data set:
miss = pd.read_excel("SF12_missing.xlsx",
                     sheet_name="data")
miss.head(3)
miss.describe()

nomiss = pd.read_excel("SF12_nomissing.xlsx",
                     sheet_name="data")
nomiss.head(3)
nomiss.describe()

