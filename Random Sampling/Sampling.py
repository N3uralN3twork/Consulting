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
    - - - - - -- - - - - - - - - - - - - - - - - - - - - - -
"""

import random
from random import sample
import numpy as np
import pandas as pd

iris = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv')

"1. Simple Random Sample without replacement:"
random.seed(1234)
test = iris.sample(n=50, random_state=123, replace=False)

"2. Simple Random Sample with replacement:"
random.seed(1234)
test2 = iris.sample(n=50, random_state=123, replace=True)

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

systematic(iris, step=3)

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
        - stratified_sample
        - stratified_sample_report
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


stratified_sample(iris, strata=["species"], size=6, seed=1234, keep_index=True)

"5. Cluster Random Sample:"
def cluster(df, nClusters: int, size: int):
    check = len(df)/nClusters
    if check.is_integer() is not True:
        raise ValueError("STOP:")
    test = np.array_split(df, nClusters)
    ls = []
    for dfs in test:
        ls.append(dfs.sample(size))
    result = pd.concat(ls)
    return result


cluster(iris, nClusters=3, size=10)
