NSites <- 3
Sites <- 3
NSubjects <- 14
BlockSize <- 7
RRatio <- 4/3


vector <- c() # Initiate an empty vector
for (i in seq(1:(NSites*(NSubjects/BlockSize)))){ # For each block
  for (j in 1:BlockSize){ # Print "BlockSize" times
    vector = append(vector, i)} # Append the results to the previously empty vector
}
Ts = RRatio/(RRatio+1) # Compute the proportion of Ts needed
Cs = 1-Ts # Compute the proportion of Cs needed
TorC = block_ra(blocks = vector, # Using the first column:
                conditions = c("T", "C"), # 2 groups are the Ts and Cs
                prob_each = c(Ts, Cs)) # The prob. that T or C appears
TLC = data.frame(TorC)

max(rle(as.vector(TLC$TorC))$lengths)










