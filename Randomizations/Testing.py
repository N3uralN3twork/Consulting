import random
import pandas as pd
import numpy as np

ls = [1, 2, 3, 4]
random.shuffle(ls)

def test(NSubjects, RRatio):
    timesT = NSubjects*(RRatio/(RRatio+1))
    timesC = (NSubjects - timesT)
    x = np.array(["T", "C"])
    TLC = np.repeat(x, repeats=[timesT, timesC], axis=0)
    return TLC

test(NSubjects=30, RRatio=1)


