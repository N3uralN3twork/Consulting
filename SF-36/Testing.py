import numpy as np
import pandas as pd


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
    elif Missing > 0 or Missing < 3:
        """b2 = np.nanmean([item9c, item9d, item9f, item9h])
        c2 = np.nanmean([item9b, item9d, item9f, item9h])
        d2 = np.nanmean([item9b, item9c, item9f, item9h])
        f2 = np.nanmean([item9b, item9c, item9d, item9h])
        h2 = np.nanmean([item9b, item9c, item9d, item9f])
        b2 + c2 + d2 + f2 + h2"""
        result = (np.nansum(List) * 5) / (5 - Missing)
        return result
    else:
        return "Error"


rawMH(None, 5, 3, 5, 5, 3)
rawMH(None, 3, 3, 2, 4, 2)
rawMH(None, 2, 1, 5, 4, 5)
rawMH(None, np.nan, 4, np.nan, 4, 1)
