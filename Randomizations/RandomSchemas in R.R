"
Title: Randomization Schema
Author: Matt Quinn
Date: August 2nd 2020
"

# Building the design schema for 1 site:
SCHEMA <- function(prefix = "AAA", NSubjects, NSites=1, NFactors){
  row_count = (NSubjects * NSites)
  col_count = (NFactors)
  result <- vector("list", NSubjects)
  for (i in seq(1, NSubjects)){
    if (i < 10){
      result[[i]] <- paste(prefix, i, sep = "0")
    } else {
      result[[i]] <- paste(prefix, i, sep = "")}}
  result <- t(as.data.frame(result))
  TLC = data.frame(TorC = sample(t(rep(c("T", "C"), 15))))
  mattrix <- matrix(nrow = row_count, ncol = col_count)
  final = data.frame(ID = result, mattrix, row.names = NULL)
  final = final[sample(nrow(final)), ]
  final = data.frame(Order = 1:row_count, final)
  final = data.frame(ID = paste(final$ID, TLC$TorC, sep = ""), Order = seq(1:row_count), mattrix, row.names = NULL)
  return(final)
}

matt = SCHEMA(prefix = "AAA", NSubjects = 30, NFactors = 3)





