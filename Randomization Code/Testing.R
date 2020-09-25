Sites = 1
BlockSize = 10
NSubjects = 50
RRatio = 2

test3 <- NSubjects*(RRatio/(RRatio+1))%%RRatio == 0
test3
