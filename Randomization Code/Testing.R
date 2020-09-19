BlockSize = 12
NSubjects = 48
RRatio = 3

# Adding the Ts and Cs:
blocks = block.random(n = NSubjects, ncond = BlockSize) # Create blocks first
Ts = RRatio/(RRatio+1) # Compute the number of Ts needed
Cs = 1-Ts # Compute the number of Cs needed
TorC = block_ra(blocks = blocks[ , 1], # Using the first column:
                conditions = c("T", "C"), # 2 groups are the Ts and Cs
                prob_each = c(Ts, Cs)) # The prob. that T or C appears
TLC = data.frame(TorC)
table(TLC)

