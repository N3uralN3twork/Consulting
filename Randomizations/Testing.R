schema <- function(Sites = NULL, NSubjects, RRatio = NULL, NFactors){
  
  # Start with 2 empty data matrices:
  matt = matrix(NA, nrow = length(Sites), ncol = NSubjects)
  final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = NFactors+1)
  
  # Assign names to each column, otherwise you'll get an error:
  dimnames(matt) = list(Sites)
  
  # Assign letters to each subject @ each site:
  for (i in Sites){
    for (j in NSubjects){
      matt[i, ] = rep(i, times = NSubjects) # Row-wise
    }
  }

  # Return the transpose of the matrix:
  matt = as.data.frame(t(matt)) # Turn into a dataframe as well
  
  return(matt)}
  
  # Adding the numbers to the end via a simple if-then-else statement
  for (column in matt){
    matt[column, ] = if_else(row_number(column) < 10,
                             true = paste(column, "0", row_number(column), sep = ""),
                             false = paste(column, row_number(column), sep = ""))
  }
  row.names(matt) = NULL # Just for aesthetics, no functional purpose
  
  #Select the first column & rows between [nrow(data) -> NSubjects]:
  matt = matt[NSubjects+1:(nrow(matt)-NSubjects), 1]
  
  # Calculating the number of T's and C's:
  for (i in (NSubjects+1)){ # +1 because it will drop off at NSubjects otherwise
    timesT = NSubjects*(RRatio/(RRatio+1))
    timesC = (NSubjects - timesT)
    TLC = data.frame(TorC = sample(t(rep(c("T", "C"), times = c(timesT, timesC)))))
  }
  # Repeat the process above for each site
  TLC = data.frame(TorC = rep(TLC$TorC, times = length(Sites)))
  
  # Shuffle the data randomly:
  matt = sample(matt)
  
  # Turn the data matrix into a data.frame:
  matt = as.data.frame(matt)
  
  # Concatenate both objects into a single dataframe
  result = data.frame(c(TLC, matt))
  
  # Use the "unite" function to concatenate both columns into a single column
  result = result %>% # using the pipe operator from the dplyr syntax
    unite(Codes, c("matt", "TorC"), sep = "")
  
  # For each column, append the result to the previously empty matrix above
  for(column in 0:1){
    final[, column] <- result[ , 1] # Copy only the first column 
  }
  
  # Return the end result:
  return(final)
}


FINAL <- schema(Sites = c("AAA", "BBB", "CCC"), NSubjects = 30, RRatio = 1, NFactors = 3)
