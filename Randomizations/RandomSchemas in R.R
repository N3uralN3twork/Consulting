"
Title: Randomization Schema
Author: Matt Quinn
Date: August 2nd 2020
"

setwd("C:/Users/miqui/OneDrive/Consulting/Randomizations")

# For each site do the following:
  # Store site in dataframe N times each
  # Add numbers (1-K) to end of each site code in dataframe
  # Randomly assign (T/C) to end of each site code in dataframe


# Randomization Ratio:
  # Number of T subjects == (N/(N+D))*NSubjects:
  # Number of C subjects == (NSubjects - TSubjects)


"Building the design schema for 1 site:"
SCHEMA <- function(prefix = "AAA", NSubjects, NSites=1, NFactors, RRatio){
  row_count = (NSubjects * NSites)
  col_count = (NFactors)
  result <- vector("list", length = NSubjects) # Start with an empty list
  # Assigning the numbers
  for (i in seq(1, NSubjects)){
    if (i < 10){
      result[[i]] <- paste(prefix, i, sep = "0")
    } else {
      result[[i]] <- paste(prefix, i, sep = "")}}
  result <- t(as.data.frame(result))
  # Determining the number of T's and C's
  timesT = NSubjects*(RRatio/(RRatio+1))
  timesC = (NSubjects - timesT)
  TLC = data.frame(TorC = sample(t(rep(c("T", "C"), times = c(timesT, timesC)))))
  # Creating the design matrix
  mattrix <- matrix(nrow = row_count, ncol = col_count)
  final = data.frame(ID = result, mattrix, row.names = NULL)
  final = final[sample(nrow(final)), ]
  final = data.frame(Order = 1:row_count, final)
  final = data.frame(ID = paste(final$ID, TLC$TorC, sep = ""), Order = seq(1:row_count), mattrix, row.names = NULL)
  return(final)
}

matt = SCHEMA(prefix = "AAA", NSubjects = 15, NFactors = 3, RRatio = 2)


# Multiple Sites:


test <- function(Sites = NULL, NSubjects){
  matt = matrix(NA, nrow = length(Sites), ncol = NSubjects) # Start with an empty matrix
  dimnames(matt) = list(Sites)
  for (i in Sites){
    for (j in NSubjects){
      #print(rep(i, NSubjects))
      matt[i, ] = rep(i, NSubjects)
    }
  }
  matt = t(matt)} # Return the transpose of the matrix


Sites <- test(Sites = c("AAA", "BBB"), NSubjects = 5)



