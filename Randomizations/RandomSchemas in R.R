library(dplyr)
library(ISLR)
library(randomizeR)



# Printing out the codes:
for (i in seq(1, 30)){
  if (i < 10){
    print(paste("AAA", i, sep = "0"))
  } else {
    print(paste("AAA", i, sep = ""))
  }
}


# Building the design schema:
SCHEMA <- function(NSubjects, NSites, NFactors){
  row_count = (NSubjects * NSites)
  col_count = (NFactors)
  ID = seq(1:row_count)
  matt = matrix(nrow = row_count, ncol = col_count)
  return(data.frame(ID=1:row_count, matt))
}

matt = SCHEMA(NSubjects = 30, NSites = 1, NFactors = 3)
