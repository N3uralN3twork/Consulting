"
Title: Randomization Schema
Author: Matt Quinn
Date: August 2nd 2020
Finished on: August 6th 2020
Class: STA 635 Consulting and Programming
"

setwd("C:/Users/miqui/OneDrive/Consulting/Randomizations")


################################################################################
###                           NOTES:                                         ###
################################################################################
# INPUT:
  # A list of site codes (character)
  # The number of subjects per site
  # The randomization ratio (>= 1)
  # Number of factors in your experiment

# OUTPUT:
  # A sequential list of N codes inside a dataframe object
  # An empty data vector for each factor

# For each site do the following:
  # Store site in dataframe N times each
  # Add numbers (1-K) to end of each site code in dataframe
  # Randomly assign (T/C) to end of each site code in dataframe

# Assigning the numbers:
   # Based on your row number for each site
   # If less than 10, assign a "0" between the code and the number
   # Otherwise, assign no space between the code and the number

# Randomization Ratio:
  # Number of Treatment subjects == (N/(N+D))*NSubjects:
  # Number of Control subjects == (NSubjects - TSubjects)
  # (1, 1/2) , (2, 2/3), (3, 3/4), (4, 4/5), etc. = (n, n/n+1)



##################################
### SCHEMA for Multiple Sites: ###
##################################
# Multiple Sites:
library(tidyverse) # For the unite and row_number functions

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
