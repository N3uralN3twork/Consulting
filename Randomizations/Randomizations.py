"""
This is for the randomization schemas project in the consulting class
Author: Matthias Quinn
Goal: Develop schemas given certain conditions
More specific goal: Goal: S subjects at T sites in blocks of B where ratio is N:D
Date Began: Dec. 25, 2019
"""

##################################################################
###                         Data Prerequisites:                ###
##################################################################
import os
os.chdir("C:/Users/miqui/OneDrive/Consulting/Randomizations")
os.listdir()
##################################################################
###                         Schema Making:                     ###
##################################################################
import numpy as np

" Goal: S subjects at T sites in blocks of B where ratio is N:D"

def schema(Sites, NSubjects, RRatio=1):
    matt = np.empty(shape=[len(Sites), NSubjects])
    john = []
    jake = np.reshape(np.repeat(np.nan, repeats=(NSubjects*len(Sites))), (len(Sites), NSubjects), "F")
    for i in Sites:
        for j in range(NSubjects):
          john.append(np.repeat(i, repeats=NSubjects))
    return john

schema(Sites=["AAA"], NSubjects=10)

np.reshape(np.repeat(np.nan, repeats=20), (2, 10), "F")
np.empty(shape=[2,10])
