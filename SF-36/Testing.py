"Hello".isalpha()

def check(df):
    ls = []
    for column in df:
        for row in df:
            ls.append(row.isalpha())
    Trues = ls.count(True)
    if Trues >= 1:
        raise ValueError("Must not have any characters in your data set")
    else:
        print("Your data set looks good")

check(df=df)