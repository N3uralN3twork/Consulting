import numpy as np
import pandas as pd

# There should be 165 from Bing, 76 from MapQuest, and 9 from Both
test2 = pd.DataFrame(index=range(0, len(UniqueNames)),
                     columns=[stratum, "samp_size"])
test2[stratum] = UniqueNames
test2["samp_size"] = sizes
test2

# controlling variable to create the dataframe or append to it
first = True
for i in range(len(tmp_group)):
    # query generator for each iteration
    qry = ''
    for s in range(len(stratum)):
        value = tmp_group.iloc[i][stratum]
        n = tmp_group.iloc[i]['samp_size']

        if type(value) == str:
            value = "'" + str(value) + "'"

        if s != len(stratum) - 1:
            qry = qry + stratum + ' == ' + str(value) + ' & '
        else:
            qry = qry + stratum + ' == ' + str(value)

    # final dataframe
    if first:
        stratified_df = df.query(qry).sample(n=n, random_state=1234).reset_index(drop=(not True))
        first = False
    else:
        tmp_df = df.query(qry).sample(n=n, random_state=1234).reset_index(drop=(not True))
        stratified_df = stratified_df.append(tmp_df, ignore_index=True)

stratified_df["Source"].value_counts()

# Starting indices:
a = list(np.arange(0, len(UniqueNames), 1))
b = [i*250 for i in a]

# Ending indices:
a = list(np.arange(0, len(UniqueNames), 1))
d = [sizes[i]+a[i]*250 for i in a]

# Final dataframe:
final = test.loc[np.r_[0:165, 250:326, 500:509], :]
final = test.loc[np.r_[b[0]:d[0], b[1]:d[1], b[2]:d[2]], :]

np.r_[0:165, 250:326, 500:509]

asdf = dict(zip(b, d))
string = str(asdf)
one = string.replace("{", "")
two = one.replace("}", "")
three = two.replace(" ", "")
four = three.split(",")

print(four)

