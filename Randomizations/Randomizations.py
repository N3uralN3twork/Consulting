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
os.chdir("C:/Users/MatthiasQ.MATTQ/Desktop/Consulting Projects/Randomizations")
os.listdir()

import random
from random import shuffle
import pandas as pd
from pyDOE import *

##################################################################
###                         Schema Making:                     ###
##################################################################
" Goal: S subjects at T sites in blocks of B where ratio is N:D"


def schema1(Prefix = None, NumSubjects = 1):
    """Function to print the first and easy schema: Controlling prefix and # of subjects
    Inputs: NumSubjects
    Output: List of codes (AAA01T, or AAA30C)"""
    for i in range(1, NumSubjects + 1):
        if i < 10:
           print(Prefix, i, sep = "0")
        else:
            print(Prefix, i, sep = "")

#Testing:
schema1(Prefix = "AAA", NumSubjects = 30)
a = schema1(Prefix = "AAA", NumSubjects = 30)


#The next step involves adding treatment/control to the end

def schema2(Prefix, NumSubjects, Ratio):








