import os
import numpy as np
import pandas as pd


class Schema:

    def __init__(self):
        pass

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

    def rawGH(self, item1, item11a, item11b, item11c, item11d):
        """A function to return the raw General Health score
        Inputs: Items 1, 11a - 11d
        Output: Raw General Health score"""
        Item1Dict = {np.nan: np.nan, 1: 5, 2: 4.4, 3: 3.4, 4: 2, 5: 1}
        if item1 in Item1Dict:  # Recode
            global a  # Define "a" as a global variable (no idea what that means btw)
            a = Item1Dict[item1]  # Go through and check dictionary
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
        elif (Missing == 1 or Missing == 2):
            a2 = np.nanmean([b, c, d, e])
            b2 = np.nanmean([a, c, d, e])
            c2 = np.nanmean([a, b, d, e])
            d2 = np.nanmean([a, b, c, e])
            e2 = np.nanmean([a, b, c, d])
            return np.nansum([a2 + b2 + c2 + d2 + e2])
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
        ls = pd.Series([item9a, item9e, item9g, item9i])
        Missing = ls.isna().sum()
        if Missing >= 3:  # 3 or more are missing
            return None
        elif Missing == 0:  # None missing
            return (item9a + item9e + item9g + item9i)
        elif (Missing == 1):  # Only 1 item missing
            a3 = np.nanmean([item9e, item9g, item9i])
            b3 = np.nanmean([item9a, item9g, item9i])
            c3 = np.nanmean([item9a, item9e, item9i])
            d3 = np.nanmean([item9a, item9e, item9g])
            return (a3 + b3 + c3 + d3)
        elif (Missing == 2):  # Just 2 missing
            return (2 * (item9g + item9i))  # Yes, this is cheating a bit
        else:
            return None

    def rawSF(self, item6, item10):
        """Function to return the raw Social-Functioning score
        Inputs: Items 6 and 10
        Output: Raw Social-Functioning score"""
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

    def finale(self, df):
        Questions = df.iloc[:, 0:37]
        Answers = df.iloc[:, 37:69]
        FinalScoredData = pd.concat([Questions, Answers], axis=1)
        FinalScoredData = np.round(FinalScoredData, decimals=2)  # Round everything to 2 decimal places
        return FinalScoredData

    def writeResults(self, df, fileName):
        pd.DataFrame.to_csv(df, path_or_buf=fileName,
                            header=True, index=False)

    os.listdir()


# Initialize the sf-36 survey class:
test = Schema()

# Set the working directory and load in the dataset:
df = test.loadData()

# Prepare the data before hand; remove decimals, fix ranges, etc.
df = test.dataPrep(df=df)

# Calculate the raw scores:
df["Raw_PF"] = df.apply(lambda row: test.rawPF(row["Q3a"], row["Q3b"], row["Q3c"],
                                               row["Q3d"], row["Q3e"], row["Q3f"],
                                               row["Q3g"], row["Q3h"], row["Q3i"], row["Q3j"]), axis = 1)

df["Raw_RP"] = df.apply(lambda row: test.rawRP(row["Q4a"], row["Q4b"],
                                               row["Q4c"], row["Q4d"]), axis = 1)

df["Raw_BP"] = df.apply(lambda row: test.rawBP(row["Q7"], row["Q8"]), axis = 1)

df["Raw_GH"] = df.apply(lambda row: test.rawGH(row["Q1"], row["Q11a"], row["Q11b"],
                                               row["Q11c"], row["Q11d"]), axis = 1)

df["Raw_VT"] = df.apply(lambda row: test.rawVT(row["Q9a"], row["Q9e"],
                                               row["Q9g"], row["Q9i"]), axis = 1)

df["Raw_SF"] = df.apply(lambda row: test.rawSF(row["Q6"], row["Q10"]), axis = 1)

df["Raw_RE"] = df.apply(lambda row: test.rawRE(row["Q5a"], row["Q5b"], row["Q5c"]), axis = 1)

df["Raw_MH"] = df.apply(lambda row: test.rawMH(row["Q9b"], row["Q9c"], row["Q9d"],
                                               row["Q9f"], row["Q9h"]), axis = 1)

df = test.transformations()

df = test.standardization()

df = test.normBased()

test.writeResults(df, fileName="FinalScoredData.csv")

