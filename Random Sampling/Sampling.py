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
from random import sample
import numpy as np
import pandas as pd

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








"1. Simple Random Sample without replacement:"
random.seed(1234)
test = df.sample(n=500, random_state=123, replace=False)

"2. Simple Random Sample with replacement:"
random.seed(1234)
test2 = df.sample(n=50, random_state=123, replace=True)

"3. Systematic Random Sample:"
def systematic(df, step):
    """
    :param df: the dataframe with the data
    :param step: the step size to select each subsequent row
    :return: a systematic random sample
    """
    indices = np.arange(0, len(df), step=step)
    sys_sample = df.iloc[indices]
    return sys_sample

systematic(df, step=3)

"4. Stratified Random Sample:"
def sample_size(population, size):
    '''
    A function to compute the sample size. If not informed, a sampling
    size will be calculated using Cochran adjusted sampling formula:
        cochran_n = (Z**2 * p * q) /e**2
        where:
            - Z is the z-value. In this case we use 1.96 representing 95%
            - p is the estimated proportion of the population which has an
                attribute. In this case we use 0.5
            - q is 1-p
            - e is the margin of error
        This formula is adjusted as follows:
        adjusted_cochran = cochran_n / 1+((cochran_n -1)/N)
        where:
            - cochran_n = result of the previous formula
            - N is the population size
    Parameters
    ----------
        :population: population size
        :size: sample size (default = None)
    Returns
    -------
    Calculated sample size to be used in the functions:
    '''
    if size is None:
        cochran_n = round(((1.96)**2 * 0.5 * 0.5)/ 0.02**2)
        n = round(cochran_n/(1+((cochran_n -1) /population)))
    elif size >= 0 and size < 1:
        n = round(population * size)
    elif size < 0:
        raise ValueError('Parameter "size" must be an integer or a proportion between 0 and 0.99.')
    elif size >= 1:
        n = size
    return n

help(sample_size)


def stratified_sample(df, strata, size=None, seed=None, keep_index=True):
    '''
    It samples data from a pandas dataframe using strata. These functions use
    proportionate stratification:
    n1 = (N1/N) * n
    where:
        - n1 is the sample size of stratum 1
        - N1 is the population size of stratum 1
        - N is the total population size
        - n is the sampling size
    Parameters
    ----------
    :df: pandas dataframe from which data will be sampled.
    :strata: list containing columns that will be used in the stratified sampling.
    :size: sampling size. If not informed, a sampling size will be calculated
        using Cochran adjusted sampling formula:
        cochran_n = (Z**2 * p * q) /e**2
        where:
            - Z is the z-value. In this case we use 1.96 representing 95%
            - p is the estimated proportion of the population which has an
                attribute. In this case we use 0.5
            - q is 1-p
            - e is the margin of error
        This formula is adjusted as follows:
        adjusted_cochran = cochran_n / 1+((cochran_n -1)/N)
        where:
            - cochran_n = result of the previous formula
            - N is the population size
    :seed: sampling seed
    :keep_index: if True, it keeps a column with the original population index indicator

    Returns
    -------
    A sampled pandas dataframe based on a set of strata.
    '''
    population = len(df)
    size = sample_size(population, size)
    tmp = df[strata]
    tmp['size'] = 1
    tmp_group = tmp.groupby(strata).count().reset_index()
    tmp_group['samp_size'] = round(size / population * tmp_group['size']).astype(int)

    # controlling variable to create the dataframe or append to it
    first = True
    for i in range(len(tmp_group)):
        # query generator for each iteration
        qry = ''
        for s in range(len(strata)):
            stratum = strata[s]
            value = tmp_group.iloc[i][stratum]
            n = tmp_group.iloc[i]['samp_size']

            if type(value) == str:
                value = "'" + str(value) + "'"

            if s != len(strata) - 1:
                qry = qry + stratum + ' == ' + str(value) + ' & '
            else:
                qry = qry + stratum + ' == ' + str(value)

        # final dataframe
        if first:
            stratified_df = df.query(qry).sample(n=n, random_state=seed).reset_index(drop=(not keep_index))
            first = False
        else:
            tmp_df = df.query(qry).sample(n=n, random_state=seed).reset_index(drop=(not keep_index))
            stratified_df = stratified_df.append(tmp_df, ignore_index=True)

    return stratified_df


stratified_sample(df, strata=["species"], size=6, seed=1234, keep_index=True)

"5. Cluster Random Sample:"
def cluster(df, nClusters: int, size: int):
    check = len(df)/nClusters
    if check.is_integer() is not True:
        raise ValueError(f"STOP: can't divide {len(df)} by {nClusters}")
    test = np.array_split(df, nClusters)
    ls = []
    for dfs in test:
        ls.append(dfs.sample(size))
    result = pd.concat(ls)
    return result


cluster(df, nClusters=3, size=10)







class Sampling:
    random.seed(1234)

    def __init__(self, df):
        self.df = df

    def Shape(self):
        print(f"Your dataset has {len(self.df)} rows and {len(self.df.columns)} columns")

    def SRS_no_replace(self, n: int):
        """
        :param n: the sample size you would like to have
        :return: a dataframe
        """
        result = self.df.sample(n=n, random_state=123, replace=False)
        return result

    def SRS_replace(self, n: int):
        """
        Returns a simple random sample with replacement.
        :param n: the sample size you would like to have
        :return: a dataframe
        """
        result = df.sample(n=n, random_state=123, replace=True)
        return result

    def Systematic(self, size: int):
        """
        Returns a systematic random sample that starts at the beginning.
        Simply take every k-th element after a random start.
        Simply take every k-th element after a random start
        :param size: the sample size you would like
        :return: a systematic random sample of the data you want
        """
        step = np.floor(len(self.df) / size)
        initial = random.randint(0, step)
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
        splits = np.array_split(self.df, nClusters)
        ls = []
        for dfs in splits:
            ls.append(dfs.sample(size))
        result = pd.concat(ls)
        return result

    def Stratified(self, strata: list, size: int):
        """
        Returns a stratified random sample without replacement.
        :param strata: A list of categorical variables to stratify by
        :param size: An integer that represents the sample size you would like
        :return: A dataframe
        """

test = Sampling(df=df)
test.Shape()
test.SRS_no_replace(n=500)
test.Cluster(nClusters=2, size=500)

