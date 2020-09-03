import pandas as pd
import numpy as np


def RAW_VT(item9a, item9e, item9g, item9i):
    """
    A function to return the raw Vitality score
    Inputs: Items 9a, 9e, 9g, and 9i
    Output: Raw Vitality score
    """
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
        result = (np.nansum(List)*4)/(4-Missing)
        return result
    else:
        return None


RAW_VT(np.nan, np.nan, 3, 1)
RAW_VT(np.nan, 1, np.nan, 1)
RAW_VT(5, 5, np.nan, np.nan)


