
ls <- c(1,0,0,1,0,0,1,0,0)
sample(ls, replace = FALSE)
#NTs = (NSubjects*RRatio)
#NControl = 1-NTreats
sample(rep(rep(sample(ls, replace = FALSE), times=3), times = 3))



2%%1
x=3.2
x%%1==0

ls <- c(1, 2, 3, 4, 10.2)
for (i in ls){
  print(ls[i]%%1==0)
}
