import pandas as pd
import numpy as np


def schema(Sites, NSubjects, RRatio=1, NFactors=1):
    # Start with an empty list:
    matt = []
    jake = []
    # Assign numbers to each subject @ each site:
    for site in Sites:
        matt.append(np.repeat(site, repeats=NSubjects, axis=0))
    matt = pd.DataFrame(np.transpose(matt), columns=Sites)
    # Adding the row numbers for later since there isn't a row_number function
    matt["Row"] = range(0, NSubjects)
    """for column in matt:
        if matt["Row"] < 10:
            print(column, "0", matt["Row"])
        else:
            print(column, matt["Row"])"""
    return matt

matt = schema(Sites = ["AAA", "BBB"], NSubjects=20)
