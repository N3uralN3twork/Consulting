import pandas as pd
import numpy as np


def schema(Sites, NSubjects, RRatio=1, NFactors=1):
    # Start with an empty list:
    matt = []
    # Assign numbers to each subject @ each site:
    for site in Sites:
        matt.append(np.repeat(site, repeats=NSubjects, axis=0))
    matt = pd.DataFrame(np.transpose(matt), columns=Sites)
    return matt

schema(Sites = ["AAA", "BBB"], NSubjects=20)
