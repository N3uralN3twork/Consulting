import os
import numpy as np
import pandas as pd
# from dfply import *


class Schema:

    def __init__(self):
        self.data = None

    def loadData(self):
        path = str(input("Please enter the path to the folder: "))
        os.chdir(path=path)
        fileName = str(input("Please enter the name of the Excel file: "))
        sheet = str(input("Please enter the Excel sheet name: "))
        df = pd.read_excel(path+"/"+fileName,
                           sheet_name=sheet,
                           index_col=0)
        return df


# Initialize the sf-36 survey class:
test = Schema()

# Set the working directory and load in the dataset:
df = test.loadData()


