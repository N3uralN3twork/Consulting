"""This is for the randomization schemas project in the consulting class
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

" Goal: S subjects at T sites in blocks of B where ratio is N:D"


def schema1(Prefix = None, NSubjects = 1):
    """Function to print the first and easy schema: Controlling prefix and # of subjects
    Inputs: NumSubjects
    Output: List of codes (AAA01T, or AAA30C)"""
    for i in range(1, NSubjects + 1):
        if i < 10:
            print(Prefix, i, sep = "0")
        else:
            print(Prefix, i, sep = "")

#Testing:
schema1(Prefix = "AAA", NSubjects = 30)

#The next step involves adding treatment/control to the end
def DOE(NSites, NSubjects, NBlocks, RRatio)





