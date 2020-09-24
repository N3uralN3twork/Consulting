BlockSize = 12
NSubjects = 48
RRatio = 2

vector <- c()
for (i in seq(1:(NSubjects/BlockSize))){
  for (j in 1:BlockSize){
    vector = append(vector, i)}
}
Ts = RRatio/(RRatio+1) # Compute the proportion of Ts needed
Cs = 1-Ts # Compute the proportion of Cs needed
TorC = block_ra(blocks = vector, # Using the first column:
                conditions = c("T", "C"), # 2 groups are the Ts and Cs
                prob_each = c(Ts, Cs)) # The prob. that T or C appears
TLC = data.frame(TorC)
TLC



