"""""
This is for the randomization schemas project in the consulting class
Author: Matthias Quinn
Goal: Develop design schemas given certain conditions
More specific goal: Goal: S subjects at T sites in blocks of B where ratio is N:D
Date Began: Dec. 25, 2019
"""""

##################################################################
###                         Data Prerequisites:                ###
##################################################################
import os
os.chdir("C:/Users/miqui/OneDrive/Consulting/Randomizations")
os.listdir()
##################################################################
###                         Notes                              ###
##################################################################
"1. Python starts at 0"

##################################################################
###                         Schema Making:                     ###
##################################################################
import numpy as np
import pandas as pd

def schema(Sites, NSubjects, RRatio=1, NFactors=1):
    # Start with an empty list:
    matt = []
    # Assign numbers to each subject @ each site:
    for site in Sites:
        matt.append(np.repeat(site, repeats=NSubjects, axis=0)) # Row-wise
    matt = pd.DataFrame(np.transpose(matt), columns=Sites)
    return matt

"Testing:"
schema(Sites=["AAA", "BBB"], NSubjects=30)


