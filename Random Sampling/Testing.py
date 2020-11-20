import pandas as pd
import numpy as np

strata = ["Source"]
for name in strata:
    print(name, ":")
    print(df[name].value_counts(normalize=True), "\n")

np.round(8.901)


def Stratified(df, strata: list, size: int):
    """
    Returns a stratified random sample without replacement.
    :param strata: A list of categorical variables to stratify by
    :param size: An integer that represents the sample size you would like
    :return: A dataframe
    """
    ls = []
    for prop in df[strata].value_counts(normalize=True):  # Obtain a list of proportions for the strata
        ls.append(prop)  # Append the results to the new list (ls).

    sizes = [round(size*item) for item in ls]  # Multiply each item in list by sample size via list comprehension.

    # Error checking
    if sum(sizes) is not size:
        raise ValueError("STOP: Incorrect sample size chosen.")

    return sizes


Stratified(df, strata, size=250)

ls = []
for prop in df[strata].value_counts(normalize=True):
    print(prop)
    ls.append(prop)

size = 250
new_ls = [round(size*item) for item in ls]  # Using list comprehension to compute the proportional sample sizes

print(new_ls)
print(sum(new_ls))  # Make sure the sum adds up to the sample size you would like

