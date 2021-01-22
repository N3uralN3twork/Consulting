import pandas as pd
import numpy as np

def Cluster(df, nClusters: int, size: int):
    """
    Returns a cluster random sample from the clusters that you randomly created
    :param nClusters: the number of clusters to select from
    :param size: the sample size you would like for each cluster
    :return: a cluster random sample of the data you want
    """
    check = len(df) / nClusters
    if check.is_integer() is not True:
        raise ValueError(f"STOP: You cannot divide {len(df)} by {nClusters}")
    splits = np.array_split(df, nClusters)  # Split the df into n clusters
    ls = []
    for dfs in splits:
        ls.append(dfs.sample(size))  # This is where the random sampling occurs
    result = pd.concat(ls)
    return result





ls = []
for prop in self.df[stratum].value_counts(normalize=True):  # Obtain a list of proportions for each level of the stratum
    ls.append(prop)

df["Source"].value_counts(normalize=True)