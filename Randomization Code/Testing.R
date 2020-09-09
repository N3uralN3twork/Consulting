library(randomizr)

blocks <- rep(c("T", "C"), times = c(50, 50))
Z <- block_ra(blocks = blocks)
Z
table(blocks, Z)
table(Z)


typeof(1.00)

as.integer(1.20)
colMeans()

for (i in 1:51){
  print(i)
}


for (i in (1:51)){
  print(i)
}