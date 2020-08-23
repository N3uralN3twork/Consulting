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

    def dataPrep(self, df):
        Questions = ['Q1', 'Q2', 'Q3a', 'Q3b', 'Q3c',
                     'Q3d', 'Q3e', 'Q3f', 'Q3g', 'Q3h',
                     'Q3i', 'Q3j', 'Q4a', 'Q4b', 'Q4c',
                     'Q4d', 'Q5a', 'Q5b', 'Q5c', 'Q6',
                     'Q7', 'Q8', 'Q9a', 'Q9b', 'Q9c',
                     'Q9d', 'Q9e', 'Q9f', 'Q9g', 'Q9h',
                     'Q9i', 'Q10', 'Q11a', 'Q11b', 'Q11c', 'Q11d']

        df = df.astype({"Q1": "float64"})
        df[Questions] = df[Questions].applymap(lambda x: np.where(x.is_integer(), x, None))
        df[Questions] = df[Questions].applymap(lambda x: np.where(x > 0, x, None))

        OneToThreeColumns = ['Q3a', 'Q3b', 'Q3c',
                             'Q3d', 'Q3e', 'Q3f', 'Q3g', 'Q3h',
                             'Q3i', 'Q3j']

        df[OneToThreeColumns] = df[OneToThreeColumns].applymap(lambda x: np.where(x in range(1, 4), x, None))

        OneToFiveColumns = ["Q1", "Q2", "Q4a", "Q4b", "Q4c", "Q4d",
                            "Q5a", "Q5b", "Q5c", "Q6", "Q8", "Q9a",
                            "Q9b", "Q9c", "Q9d", "Q9e", "Q9f", "Q9g",
                            "Q9h", "Q9i", "Q10", "Q11a", "Q11b", "Q11c",
                            "Q11d"]

        df[OneToFiveColumns] = df[OneToFiveColumns].applymap(lambda x: np.where(x in range(1, 6), x, None))

        OneToSixColumns = ["Q7"]

        df[OneToSixColumns] = df[OneToSixColumns].applymap(lambda x: np.where(x in range(1, 7), x, None))

        return df

    def rawPF(self, a,b,c,d,e,f,g,h,i,j):
        ls = pd.Series([a,b,c,d,e,f,g,h,i,j])
        Mean = np.mean(ls)
        Missing = ls.isna().sum()
        if Missing > 5:
            return None
        elif Missing > 0 and Missing < 5:
            ls2 = ls.replace(np.nan, Mean)
            return sum(ls2)
        else:
            return sum(ls)

    def rawRP(self, item4a, item4b, item4c, item4d):

        """This function returns the raw role-physical score
        Inputs: Items 4a - 4d"""
        ls = pd.Series([item4a, item4b, item4c, item4d])
        Mean = np.mean(ls)
        Missing = ls.isna().sum()
        if Missing > 2:  # If more than half items are missing
            return None
        elif Missing > 0 and Missing < 2:  # Replace missing items with mean of others
            ls2 = ls.replace(np.nan, Mean)
            return sum(ls2)
        else:  # All items present, then simple sum
            return sum(ls)

    def rawBP(self, item7, item8):

        """
        A function to return the raw bodily-pain score
        Inputs: Items 7 and 8
        Output: Raw Bodily-Pain score
        """
        while np.isnan(item7) and np.isnan(item8):  # Both are missing
            return None
        while item7 > 0 and np.isnan(item8):  # Only 7 answered and not 8
            switcher = {1: 12, 2: 10.8, 3: 8.4, 4: 6.2, 5: 4.4, 6: 2}
            return switcher.get(item7, None)
        while np.isnan(item7) and item8 > 0:  # Only 8 answered
            switcher = {  # Using a switcher case statement here
                1: 12, 2: 9.5, 3: 7, 4: 4.5, 5: 2}
            return switcher.get(item8, None)
        while item7 > 0 and item8 > 0:  # Both items answered
            return {  # loops through multi-key dictionary checking for matches
                (1, 1): 12.0, (1, 2): 10.0, (1, 3): 9, (1, 4): 8, (1, 5): 7,
                (2, 1): 10.4, (2, 2): 9.4, (2, 3): 8.4, (2, 4): 7.4, (2, 5): 6.4,
                (3, 1): 9.2, (3, 2): 8.2, (3, 3): 7.2, (3, 4): 6.2, (3, 5): 5.2,
                (4, 1): 8.1, (4, 2): 7.1, (4, 3): 6.1, (4, 4): 5.1, (4, 5): 4.1,
                (5, 1): 7.2, (5, 2): 6.2, (5, 3): 5.2, (5, 4): 4.2, (5, 5): 3.2,
                (6, 1): 6.0, (6, 2): 5.0, (6, 3): 4.0, (6, 4): 3.0, (6, 5): 2.0}[(item7, item8)]
        else:
            return None

    


# Initialize the sf-36 survey class:
test = Schema()

# Set the working directory and load in the dataset:
df = test.loadData()

df = test.dataPrep(df=df)

df["Raw_PF"] = df.apply(lambda row: test.rawPF(row["Q3a"], row["Q3b"], row["Q3c"],
                                               row["Q3d"], row["Q3e"], row["Q3f"],
                                               row["Q3g"], row["Q3h"], row["Q3i"], row["Q3j"]), axis = 1)

df["Raw_RP"] = df.apply(lambda row: test.rawRP(row["Q4a"], row["Q4b"],
                                               row["Q4c"], row["Q4d"]), axis = 1)

df["Raw_BP"] = df.apply(lambda row: test.rawBP(row["Q7"], row["Q8"]), axis = 1)
