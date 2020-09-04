"""This is for the SF-36 project in Dr. Quinn's consulting class
Author: Matthias Quinn
Goal: Score the SF-36 item survey
Date Began: 9/1/2020
Date End: 9/3/2020

Source 1: https://stackoverflow.com/questions/16476924/how-to-iterate-over-rows-in-a-dataframe-in-pandas
Source 2: https://medium.com/better-programming/two-replacements-for-switch-statements-in-python-85e09638e451
Source 3: https://docs.scipy.org/doc/numpy/reference/generated/numpy.nan_to_num.html
Source 4: https://docs.scipy.org/doc/numpy/reference/generated/numpy.nanmean.html
Source 5: https://stackoverflow.com/questions/44033422/how-to-recode-integers-to-other-values-in-python
Source 6: https://stackoverflow.com/questions/11904981/local-variable-referenced-before-assignment
Source 7: https://stackoverflow.com/questions/60208/replacements-for-switch-statement-in-python?page=1&tab=votes#tab-top

What I learned:
    * While loops
    * Multi-input functions
    * How to apply multi-input functions across a data-set (using lambda)
    * Lambda functions
    * If-elif-else statements
    * Multi-key dictionaries (using ())
    * Importance of commenting your code"""

import os
import numpy as np
import pandas as pd


class SF36:

    def __init__(self):
        pass

    def loadData(self):
        path = str(input("Please enter the path to the folder: "))
        os.chdir(path=path)
        file_name = str(input("Please enter the name of the Excel file: "))
        extension = os.path.splitext(file_name)[1]  # Python starts at 0
        sheet = str(input("Please enter the Excel sheet name: "))
        if extension == ".csv":
            df = pd.read_csv(path + "/" + file_name,
                             index_col=0)
            return df
        elif extension == ".xlsx":
            df = pd.read_excel(path + "/" + file_name,
                               sheet_name=sheet,
                               index_col=0)
            return df
        else:
            raise Exception("Please input either a .csv or .xlsx data set")

    def check(self, df): # check the data set for non-numeric inputs
        ls = []
        for column in df:
            for row in df:
                ls.append(row.isalpha())
        Trues = ls.count(True)  # Count the number of Trues in the list
        if Trues >= 1:
            raise ValueError("Must not have any characters in your data set")
        else:
            print("Your data set looks good")

    def dataPrep(self, df):
        Questions = ['Q1', 'Q2', 'Q3a', 'Q3b', 'Q3c',
                     'Q3d', 'Q3e', 'Q3f', 'Q3g', 'Q3h',
                     'Q3i', 'Q3j', 'Q4a', 'Q4b', 'Q4c',
                     'Q4d', 'Q5a', 'Q5b', 'Q5c', 'Q6',
                     'Q7', 'Q8', 'Q9a', 'Q9b', 'Q9c',
                     'Q9d', 'Q9e', 'Q9f', 'Q9g', 'Q9h',
                     'Q9i', 'Q10', 'Q11a', 'Q11b', 'Q11c', 'Q11d']

        data2 = df.copy()

        df = df.astype({"Q1": "float64", "Q2": "float64", "Q3a": "float64", "Q3b": "float64", "Q3c": "float64",
                        "Q4a": "float64", "Q4b": "float64", "Q4c": "float64", "Q4d": "float64", "Q5a": "float64",
                        "Q5b": "float64", "Q5c": "float64", "Q6": "float64", "Q7": "float64", "Q8": "float64",
                        "Q9a": "float64", "Q9b": "float64", "Q9c": "float64", "Q9d": "float64", "Q9e": "float64",
                        "Q9f": "float64", "Q9g": "float64", "Q9h": "float64", "Q9i": "float64", "Q10": "float64",
                        "Q11d": "float64"})

        df[Questions] = df[Questions].applymap(lambda x: np.where(x.is_integer(), x, np.nan))
        df[Questions] = df[Questions].applymap(lambda x: np.where(x > 0, x, np.nan))

        OneToThreeColumns = ['Q3a', 'Q3b', 'Q3c',
                             'Q3d', 'Q3e', 'Q3f', 'Q3g', 'Q3h',
                             'Q3i', 'Q3j']

        df[OneToThreeColumns] = df[OneToThreeColumns].applymap(lambda x: np.where(x in range(1, 4), x, np.nan))

        OneToFiveColumns = ["Q1", "Q2", "Q4a", "Q4b", "Q4c", "Q4d",
                            "Q5a", "Q5b", "Q5c", "Q6", "Q8", "Q9a",
                            "Q9b", "Q9c", "Q9d", "Q9e", "Q9f", "Q9g",
                            "Q9h", "Q9i", "Q10", "Q11a", "Q11b", "Q11c",
                            "Q11d"]

        df[OneToFiveColumns] = df[OneToFiveColumns].applymap(lambda x: np.where(x in range(1, 6), x, np.nan))

        OneToSixColumns = ["Q7"]

        df[OneToSixColumns] = df[OneToSixColumns].applymap(lambda x: np.where(x in range(1, 7), x, np.nan))

        return df, data2

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

        def seven():  # Recode the 7th item before summation
            return {1: 6.0, 2: 5.4, 3: 4.2, 4: 3.1, 5: 2.2, 6: 1.0}[item7]

        def eight():  # Recode the 8th item if both answered
            return {1: 5.0, 2: 4.0, 3: 3.0, 4: 2.0, 5: 1.0}[item8]

        while np.isnan(item7) and np.isnan(item8):  # Both are missing
            return None
        while item7 > 0 and np.isnan(item8):  # Only 7 answered and not 8
            return 2 * seven()  # Just mean imputation, since you divide by 1, is just 2 of the same inputs
        while np.isnan(item7) and item8 > 0:  # Only 8 answered and not 7
            switcher = {  # Using a switcher case_when statement here
                1: 12, 2: 9.5, 3: 7, 4: 4.5, 5: 2}
            return switcher.get(item8, None)
        while item7 > 0 and item8 > 0:
            if item7 == 1 and item8 == 1:  # Edge Case
                return 12
            else:
                return seven() + eight()
        else:
            return None

    def rawGH(self, item1, item11a, item11b, item11c, item11d):
        """A function to return the raw General Health score
        Inputs: Items 1, 11a - 11d
        Output: Raw General Health score"""

        oneDict = {np.nan: np.nan, 1: 5.0, 2: 4.4, 3: 3.4, 4: 2.0, 5: 1.0}.get(item1, None)
        a = oneDict
        b = item11a  # Don't change
        c = (np.abs(item11b - 5) + 1)  # Recode
        d = item11c
        e = (np.abs(item11d - 5) + 1)  # Recode
        List = pd.Series([a, b, c, d, e])
        Missing = List.isna().sum()
        if Missing == 0:  # All present
            return np.sum([a, b, c, d, e])
        elif Missing >= 3:  # 3 or more missing
            return None
        elif Missing == 1 or Missing == 2:
            result = (np.nansum(List) * 5) / (5 - Missing)
            return result
        else:
            return "Error"

    def rawVT(self, item9a, item9e, item9g, item9i):
        """A function to return the raw Vitality score
        Inputs: Items 9a, 9e, 9g, and 9i
        Output: Raw Vitality score"""
        item9a = np.abs(item9a - 5) + 1  # Recode before computation
        item9e = np.abs(item9e - 5) + 1
        item9g = item9g  # Keep same
        item9i = item9i  # Keep same
        List = pd.Series([item9a, item9e, item9g, item9i])
        Missing = List.isna().sum()
        if Missing >= 3:  # 3 or more are missing
            return None
        elif Missing == 0:  # None missing
            return (item9a + item9e + item9g + item9i)
        elif Missing == 1:  # Only 1 item missing
            a3 = np.nanmean([item9e, item9g, item9i])
            b3 = np.nanmean([item9a, item9g, item9i])
            c3 = np.nanmean([item9a, item9e, item9i])
            d3 = np.nanmean([item9a, item9e, item9g])
            return a3 + b3 + c3 + d3
        while Missing == 2:  # Just 2 missing
            result = (np.nansum(List) * 4) / (4 - Missing)
            return result
        else:
            return None

    def rawSF(self, item6, item10):
        """
        Function to return the raw Social-Functioning score
        Inputs: Items 6 and 10
        Output: Raw Social-Functioning score
        """
        while np.isnan(item6) and np.isnan(item10):  # Both missing
            return None
        while np.isnan(item6) and item10 > 0:  # Just 6 missing
            return (2 * item10)
        while item6 > 0 and np.isnan(item10):  # Just 10 missing
            return (2 * ((np.abs(item6 - 5)) + 1))
        while item6 > 0 and item10 > 0:  # Both items present
            return ((np.abs(item6 - 5)) + item10 + 1)
        else:
            return None

    def rawRE(self, item5a, item5b, item5c):
        """Function that returns that raw Role-Emotional score
        Inputs: Items 5a-5c
        Output: Raw Role-Emotional score"""
        List = pd.Series([item5a, item5b, item5c])
        Missing = np.isnan(List).sum()
        Mean = np.mean(List)
        while np.isnan(item5a) and np.isnan(item5b) and np.isnan(item5c):  # All missing
            return None
        while Missing >= 2:
            return None
        while item5a > 0 and item5b > 0 and item5c > 0:  # All items present
            return (item5a + item5b + item5c)
        while Missing == 1:  # If only missing one item
            List2 = List.replace(np.nan, Mean)
            return sum(List2)
        else:  # Prolly run forever without the below statement
            return None

    def rawMH(self, item9b, item9c, item9d, item9f, item9h):
        """A function that returns the raw mental health score
        Inputs: Items 9b, 9c, 9d, 9f, and 9h
        Output: Raw Mental Health score"""
        item9b = item9b  # Keep same
        item9c = item9c
        item9d = (np.abs(item9d - 5) + 1)  # Recode
        item9f = item9f  # Keep same
        item9h = (np.abs(item9h - 5) + 1)  # Recode
        List = pd.Series([item9b, item9c, item9d, item9f, item9h])
        Missing = List.isna().sum()
        if Missing >= 3:  # 3 or more missing
            return None
        elif Missing == 0:  # All items present
            return (item9b + item9c + item9d + item9f + item9h)
        elif (Missing > 0 or Missing < 3):
            b2 = np.nanmean([item9c, item9d, item9f, item9h])
            c2 = np.nanmean([item9b, item9d, item9f, item9h])
            d2 = np.nanmean([item9b, item9c, item9f, item9h])
            f2 = np.nanmean([item9b, item9c, item9d, item9h])
            h2 = np.nanmean([item9b, item9c, item9d, item9f])
            return (b2 + c2 + d2 + f2 + h2)
        else:
            return "Error"

    def transformations(self):
        df["Transformed_PF"] = ((df["Raw_PF"] - 10) / 20) * 100
        df["Transformed_RP"] = ((df["Raw_RP"] - 4) / 16) * 100
        df["Transformed_BP"] = ((df["Raw_BP"] - 2) / 10) * 100
        df["Transformed_GH"] = ((df["Raw_GH"] - 5) / 20) * 100
        df["Transformed_VT"] = ((df["Raw_VT"] - 4) / 16) * 100
        df["Transformed_SF"] = ((df["Raw_SF"] - 2) / 8) * 100
        df["Transformed_RE"] = ((df["Raw_RE"] - 3) / 12) * 100
        df["Transformed_MH"] = ((df["Raw_MH"] - 5) / 20) * 100
        return df

    def standardization(self):
        df["Standardized_PF"] = ((df["Transformed_PF"] - 83.29094) / 23.75883)
        df["Standardized_RP"] = ((df["Transformed_RP"] - 82.50964) / 25.52028)
        df["Standardized_BP"] = ((df["Transformed_BP"] - 71.32527) / 23.66224)
        df["Standardized_GH"] = ((df["Transformed_GH"] - 70.84570) / 20.97821)
        df["Standardized_VT"] = ((df["Transformed_VT"] - 58.31411) / 20.01923)
        df["Standardized_SF"] = ((df["Transformed_SF"] - 84.30250) / 22.91921)
        df["Standardized_RE"] = ((df["Transformed_RE"] - 87.39733) / 21.43778)
        df["Standardized_MH"] = ((df["Transformed_MH"] - 74.98685) / 17.75604)
        return df

    def normBased(self):
        df["NormBased_PF"] = (50 + (df["Standardized_PF"] * 10))
        df["NormBased_RP"] = (50 + (df["Standardized_RP"] * 10))
        df["NormBased_BP"] = (50 + (df["Standardized_BP"] * 10))
        df["NormBased_GH"] = (50 + (df["Standardized_GH"] * 10))
        df["NormBased_VT"] = (50 + (df["Standardized_VT"] * 10))
        df["NormBased_SF"] = (50 + (df["Standardized_SF"] * 10))
        df["NormBased_RE"] = (50 + (df["Standardized_RE"] * 10))
        df["NormBased_MH"] = (50 + (df["Standardized_MH"] * 10))
        return df

    def finale(self, Answers, Questions):
        FinalScoredData = pd.concat([Questions, Answers], axis=1)
        FinalScoredData = np.round(FinalScoredData, decimals=2)  # Round everything to 2 decimal places
        return FinalScoredData

    def writeResults(self, df, fileName):
        pd.DataFrame.to_csv(df, path_or_buf=fileName,
                            header=True, index=True,
                            decimal=".")

    os.listdir()


# Initialize the sf-36 survey object:
test = SF36()

# Set the working directory and load in the dataset:
df = test.loadData()

# Check for any string/character values in your data set:
test.check(df)

# Prepare the data before hand by: removing decimals, fixing ranges, etc.
df, Questions = test.dataPrep(df=df)

# Calculate the raw scores:
df["Raw_PF"] = df.apply(lambda row: test.rawPF(row["Q3a"], row["Q3b"], row["Q3c"],
                                               row["Q3d"], row["Q3e"], row["Q3f"],
                                               row["Q3g"], row["Q3h"], row["Q3i"], row["Q3j"]), axis=1)

df["Raw_RP"] = df.apply(lambda row: test.rawRP(row["Q4a"], row["Q4b"],
                                               row["Q4c"], row["Q4d"]), axis=1)

df["Raw_BP"] = df.apply(lambda row: test.rawBP(row["Q7"], row["Q8"]), axis=1)

df["Raw_GH"] = df.apply(lambda row: test.rawGH(row["Q1"], row["Q11a"], row["Q11b"],
                                               row["Q11c"], row["Q11d"]), axis=1)

df["Raw_VT"] = df.apply(lambda row: test.rawVT(row["Q9a"], row["Q9e"],
                                               row["Q9g"], row["Q9i"]), axis=1)

df["Raw_SF"] = df.apply(lambda row: test.rawSF(row["Q6"], row["Q10"]), axis=1)

df["Raw_RE"] = df.apply(lambda row: test.rawRE(row["Q5a"], row["Q5b"], row["Q5c"]), axis=1)

df["Raw_MH"] = df.apply(lambda row: test.rawMH(row["Q9b"], row["Q9c"], row["Q9d"],
                                               row["Q9f"], row["Q9h"]), axis=1)

df = test.transformations()

df = test.standardization()

df = test.normBased()

Questions = Questions.iloc[:, 0:36]
Answers = df.iloc[:, 36:69]

final = test.finale(Answers=Answers, Questions=Questions)

test.writeResults(final, fileName="FinalScoredData.csv")
