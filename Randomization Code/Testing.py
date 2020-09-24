import numpy as np
import pandas as pd


class Schema:

    def __init__(self):
        pass

    def emptyList(self):
        LETTERS = ["AAA", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ", "KKK", "LLL", "MMM",
                   "NNN", "OOO", "PPP", "QQQ", "RRR", "SSS", "TTT", "UUU", "VVV", "WWW", "XXX", "YYY", "ZZZ"]

        Sites = int(input("Please enter the number of sites: "))
        NSubjects = int(input("Please enter the number of subjects per site: "))
        matt = []
        for i in LETTERS:
            for j in range(NSubjects):
                matt.append([i, j])
        return np.transpose(matt)


test = Schema()

test.emptyList()

ls = []
NSubjects = 48
BlockSize = 12
for i in range(1, (NSubjects/BlockSize)+1):
    for j in range(1, BlockSize):
        print(i)



