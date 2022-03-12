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






seq = [2, 7, 4, 4, 2, 5, 2, 5, 10, 12, 5, 5, 5, 5, 6, 20, 1]
result = 1
max_result = 0
last_seen = seq[0]
for v in seq[1:]:
    if v == last_seen:
        result += 1
    else:
        if result > max_result:
            max_result = result
        last_seen = v
        result = 1
print(max_result)
# just in case the longest sequence would be at the end of your list...
if result > max_result:
    max_result = result




def long_repeat(line):
    count = 1
    max_count = 0
    prev_ch = None
    for ch in line:
        if ch == prev_ch:
            count += 1
            max_count = max(max_count, count)
        else:
            count = 1
        prev_ch = ch
    return max_count

long_repeat("AAABAC")





