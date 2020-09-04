import numpy as np
import pandas as pd

def rawGH(item1, item11a, item11b, item11c, item11d):
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


rawGH(2, 1, 5, 3, 2)  # 13.4
rawGH(5, 2, 2, 3, 3)  # 13
rawGH(2, np.nan, np.nan, np.nan, 2)  # None
rawGH(4, 3, np.nan, 3, 5)  # 11.25
rawGH(np.nan, 1, 3, 3, 1)  # 15
rawGH(np.nan, 4, 5, 3, 4)  # 12.5

