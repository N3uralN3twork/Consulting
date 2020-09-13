library(randomizr)
"BlockSize of 10 = size to sample from
break up subjects into blocks
split those 100 subjects into blocks
use the blocksize to determine how big of a sample to take
use the replicate function to determine how many times you want to run the function"


block_ra(test5$Site,
         conditions = c("T", "C"),
         prob_each = c(0.5, 0.5))

# Load built-in dataset
data(HairEyeColor)
HairEyeColor <- data.frame(HairEyeColor)

# Transform so each row is a subject
# Columns describe subject's hair color, eye color, and gender
hec <- HairEyeColor[rep(1:nrow(HairEyeColor),
                        times = HairEyeColor$Freq), 1:3]

N <- nrow(hec)

# Fix the rownames
rownames(hec) <- NULL


hec <- within(hec,{
  Y0 <- rnorm(n = N,mean = (2*as.numeric(Hair) + -4*as.numeric(Eye) + -6*as.numeric(Sex)), sd = 5)
  Y1 <- Y0 + 6*as.numeric(Hair) + 4*as.numeric(Eye) + 2*as.numeric(Sex)
})

hec <- within(hec,{
  Z_blocked <- complete_ra(N = N, m_each = c(100, 200, 292),
                           conditions = c("control", "placebo", "treatment"))
  id_var <- 1:nrow(hec)
})

hec
