df["hs_grad"].value_counts()

test = df.dropna(subset=["hs_grad"])
test["hs_grad"].value_counts()

test.dropna(subset=["hs_grad"], inplace=True)
