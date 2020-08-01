
import pandas as pd
import numpy as np

data = pd.read_excel("Practice SF-36 data.xlsx",
                     sheet_name = "Practice SF-36 data")

row_count = data.shape[0]
col_count = data.shape[1] # Nice

for i in range(1, row_count):
    for j in range(2, col_count):
        if np.isnan(data.iloc[i, j]):
            data.iloc[i, j] == np.NaN
            continue
        if data.iloc[i, j] < 0:
            data.iloc[i, j] == np.NaN
            continue
        if data.iloc[i, j].is_integer():
            data.iloc[i, j] == data.iloc[i, j]
        else:
            data.iloc[i, j] == np.NaN


