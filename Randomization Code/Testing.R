library(randomizr)

blocks <- rep(c("T", "C"), times = c(50, 50))
Z <- block_ra(blocks = blocks)
Z
table(blocks, Z)
table(Z)


colMeans()