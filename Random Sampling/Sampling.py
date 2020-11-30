"""
Beware the dragon!
                _ ___                /^^\ /^\  /^^\_
    _          _@)@) \            ,,/ '` ~ `'~~ ', `\.
  _/o\_ _ _ _/~`.`...'~\        ./~~..,'`','',.,' '  ~:
 / `,'.~,~.~  .   , . , ~|,   ,/ .,' , ,. .. ,,.   `,  ~\_
( ' _' _ '_` _  '  .    , `\_/ .' ..' '  `  `   `..  `,   \_
 ~V~ V~ V~ V~ ~\ `   ' .  '    , ' .,.,''`.,.''`.,.``. ',   \_
  _/\ /\ /\ /\_/, . ' ,   `_/~\_ .' .,. ,, , _/~\_ `. `. '.,  \_
 < ~ ~ '~`'~'`, .,  .   `_: ::: \_ '      `_/ ::: \_ `.,' . ',  \_
  \ ' `_  '`_    _    ',/ _::_::_ \ _    _/ _::_::_ \   `.,'.,`., \-,-,-,_,_,
   `'~~ `'~~ `'~~ `'~~  \(_)(_)(_)/  `~~' \(_)(_)(_)/ ~'`\_.._,._,'_;_;_;_;_;
"""
"""
     - - - - - -- - - - - - - - - - - - - - - - - - - - - - -
    Name - Consulting # 9 - Sampling Methods
    Class: STA 635 - Consulting
    Goal - Random Sampling
    Detail：Create sampling functions for the following:
            * Simple Random Sampling (without replacement)
            * Simple Random Sampling (with replacement)
            * Systematic Random Sampling
            * Stratified Random Sampling
            * Cluster Random Sampling
    Author: Matthias Quinn
    Github: https://github.com/N3uralN3twork
    Date: 13th November 2020
    Sources:
            https://stackoverflow.com/questions/16096627/selecting-a-row-of-pandas-series-dataframe-by-integer-index
            https://github.com/flaboss/python_stratified_sampling/blob/master/stratifiedSample.py
            https://smoosavi.org/datasets/us_accidents
            https://stats.stackexchange.com/questions/324702/is-the-month-ordinal-or-nominal-variable
            http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/MetQ/Talk2.pdf
            https://stackoverflow.com/questions/8194959/how-to-multiply-individual-elements-of-a-list-with-a-number
            https://stackoverflow.com/questions/19790790/splitting-dataframe-into-multiple-dataframes
            http://home.iitk.ac.in/~shalab/sampling/chapter4-sampling-stratified-sampling.pdf
            https://stackoverflow.com/questions/47965716/how-to-select-multi-range-of-rows-in-pandas-dataframe
            https://stackoverflow.com/questions/7844118/how-to-convert-comma-delimited-string-to-list-in-python
            https://pandas.pydata.org/pandas-docs
            https://stackoverflow.com/questions/32957441/putting-many-python-pandas-dataframes-to-one-excel-worksheet
            https://www.questionpro.com/blog/systematic-sampling/

    - - - - - -- - - - - - - - - - - - - - - - - - - - - - -
"""
###############################################################################
###                     1.  Define Working Directory                        ###
###############################################################################
import os
abspath = os.path.abspath("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Random Sampling")
os.chdir(abspath)
os.listdir()
###############################################################################
###                      2. Import Libraries                                ###
###############################################################################
import random
import numpy as np
import pandas as pd

# The next step takes a long time for some reason; not really sure why...
accidents = pd.read_excel("SummerAccidents2020.xlsx", sheet_name="Data", header=0, verbose=True)

Categorical = list(accidents.select_dtypes(include=['object', 'category']).columns)
Continuous = list(accidents.select_dtypes(include=['int64', 'float64']).columns)

Continuous
Categorical

"Tabulation Data"
for name in Categorical:
    print(name, ":")
    print(accidents[name].value_counts(), "\n")

"Select the 30 variables we want to include in a list:"
vars_want = ["ID", "Source", "TMC", "Severity", "Start_Time", "End_Time",
             "Start_Lat", "Start_Lng", "Distance(mi)", "Description", "Side",
             "City", "County", "State", "Zipcode", "Temperature(F)", "Wind_Chill(F)",
             "Humidity(%)", "Pressure(in)", "Visibility(mi)", "Wind_Direction",
             "Wind_Speed(mph)", "Precipitation(in)", "Astronomical_Twilight", "Weather_Timestamp",
             "Airport_Code", "Timezone", "Street", "Month", "Year"]
len(vars_want)

df = accidents[vars_want]   # Filter by the variables we chose

"Missing Value Analysis"
# To see what % of the data is missing for each variable
missing_values = df.isnull().sum() / len(df) * 100
missing_values[missing_values > 0].sort_values(ascending=False)
print(missing_values)


# Final Sampling class:
class Sampling:
    random.seed(1234)

    def __init__(self, df):
        self.df = df

    def Shape(self):
        """
        Retrieves the shape of your dataset
        """
        print(f"Your dataset has {len(self.df)} rows and {len(self.df.columns)} columns")

    def SRS(self, size: int, replace=False):
        """
        Returns a simple random sample from a dataframe
        :param size: the desired sample size you would like to have
        :param replace: should sampling be done with replacement?
        :return: a simple random sample
        """
        if size <= 0:
            raise ValueError("STOP: the sample size should be greater than 0")

        result = self.df.sample(n=size, random_state=123, replace=replace)
        return result

    def Systematic(self, size: int):
        """
        Returns a linear systematic random sample that starts at the beginning.
        Simply take every k-th element after a random start from 1 to k.
        :param size: the sample size you would like
        :return: a systematic random sample of the data you want
        """
        step = np.floor(len(self.df) / size)
        initial = random.randint(1, step)
        indices = np.arange(initial, len(self.df), step=step)
        result = self.df.iloc[indices]
        return result

    def Cluster(self, nClusters: int, size: int):
        """
        Returns a cluster random sample from the clusters that you randomly created
        :param nClusters: the number of clusters to select from
        :param size: the sample size you would like for each cluster
        :return: a cluster random sample of the data you want
        """
        check = len(self.df) / nClusters
        if check.is_integer() is not True:
            raise ValueError(f"STOP: You cannot divide {len(self.df)} by {self.nClusters}")
        splits = np.array_split(self.df, nClusters)  # Split the df into n clusters
        ls = []
        for dfs in splits:
            ls.append(dfs.sample(size))  # This is where the random sampling occurs
        result = pd.concat(ls)
        return result

    def Stratified(self, stratum: str, size: int):
        """
        Returns a stratified random sample without replacement.
        :param stratum: A categorical variable as a string (only supports 1 variable at this time)
        :param size: An integer that represents the total sample size you would like
        :return: A dataframe of selected size
        """
        ls = []
        for prop in self.df[stratum].value_counts(normalize=True):  # Obtain a list of proportions for each level of the stratum
            ls.append(prop)  # Append the results to the previously-empty list (ls).

        sizes = [round(size * item) for item in ls]  # Multiply each item in list by sample size via list comprehension.
        print(sizes)

        UniqueNames = self.df[stratum].unique()  # Get the levels of the stratum

        groupSizes = pd.DataFrame(index=range(0, len(UniqueNames)),
                                  columns=[stratum, "samp_size"])
        groupSizes[stratum] = UniqueNames
        groupSizes["samp_size"] = sizes

        # controlling variable to create the dataframe or append to it
        first = True
        for i in range(len(groupSizes)):
            # query generator for each iteration
            qry = ''
            for s in range(len(stratum)):
                value = groupSizes.iloc[i][stratum]
                n = groupSizes.iloc[i]['samp_size']

                if type(value) == str:
                    value = "'" + str(value) + "'"

                if s != len(stratum) - 1:
                    qry = qry + stratum + ' == ' + str(value) + ' & '
                else:
                    qry = qry + stratum + ' == ' + str(value)

            # final dataframe
            if first:
                final = self.df.query(qry).sample(n=n, random_state=1234, replace=False).reset_index(drop=(not True))
                first = False
            else:
                tmp_df = self.df.query(qry).sample(n=n, random_state=1234, replace=False).reset_index(drop=(not True))
                final = final.append(tmp_df, ignore_index=True)

        # Error checking
        if sum(sizes) is not size:
            raise ValueError("STOP: Invalid sample size chosen.")

        return final

    @staticmethod
    def write(wbName, df_list, sheets_list):
        """
        Writes the results of your random samples to an Excel workbook
        :param wbName: the name you would like to call your file
        :param df_list: a list of dataframes that contain your samples
        :param sheets_list: the names of the Excel worksheets
        :return: an Excel workbook
        """
        writer = pd.ExcelWriter(wbName, engine='xlsxwriter')
        for dataframe, sheet in zip(df_list, sheets_list):
            dataframe.to_excel(writer, sheet_name=sheet, startrow=0, startcol=0)
        writer.save()


# Testing:
test = Sampling(df=df)
test.Shape()
SRS = test.SRS_no_replace(n=500)
Systematic = test.Systematic(size=250)
Cluster = test.Cluster(nClusters=2, size=125)
Stratified = test.Stratified(stratum="Source", size=250)
