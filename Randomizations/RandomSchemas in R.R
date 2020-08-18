"
Title: Randomization Schema
Author: Matt Quinn
Date: August 2nd 2020
Finished on: August 6th 2020
Class: STA 635 Consulting and Programming
"

setwd("C:/Users/miqui/OneDrive/Consulting/Randomizations")

library(tidyverse) # For the unite and row_number functions

################################################################################
###                           NOTES:                                         ###
################################################################################
# INPUT:
  # A list of site codes (character)
  # The number of subjects per site (integer)
  # The randomization ratio (>= 1)
  # Number of factors in your experiment (>= 0)

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

schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL){
  
  ### Error-checking: ###
  # Null value for sites:
  if (is.null(Sites) == TRUE){
    stop("Please enter either an integer or site prefixes")
  }
  # Unique site codes:
  test1 = any(duplicated(Sites))
  if (test1 == TRUE){
    stop("Please enter unique site codes")
  }
  # Non-positive number of sites:
  if (is.numeric(Sites) && Sites <= 0){
    stop("Please enter a valid number of sites (>=1)")
  }
  # Non-positive number of subjects:
  test2 <- any(NSubjects <= 0)
  if (test2 == TRUE){
    stop("Please enter a positive integer for the number of subjects per site")
  }
  # Improper Randomization Ratio:
  if (is.character(RRatio) == TRUE){
    stop("The randomization ratio must be a numeric data type")
  }
  
  test3 <- NSubjects*(RRatio/(RRatio+1))%%1 == 0
  if (test3 == TRUE){
    stop("The randomization ratio must adhere to NSubjects*(RRatio/RRatio+1)")
  }
  
  # Designing the schema:
  # If the input to sites is NUMERIC number
  if (is.numeric(Sites) == TRUE){
    matt = c() # Start with an empty vector
    final = matrix(NA, nrow = Sites*NSubjects, ncol = 1)
    for (letter in LETTERS){
      result = rep(letter, times = 3)
      result = paste(result, collapse = "")
      matt[letter] = result
    }
    matt = data.frame(t(matt))
    matt = matt %>%
      uncount(NSubjects)
    matt = matt[1:NSubjects, 1:Sites]
    rownames(matt) = NULL
  }
  # If the input to sites is a CHARACTER vector
  else if (is.vector(Sites) == TRUE){
    matt = matrix(NA, nrow = length(Sites), ncol = NSubjects) 
    dimnames(matt) = list(Sites)
    final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = 1)
    for (i in Sites){
      for (j in NSubjects){
        matt[i, ] = rep(i, times = NSubjects) # Row-wise
      }
    }
    matt = as.data.frame(t(matt))
    rownames(matt) = NULL
    matt = data.frame(matt)
  }
  # Adding the numbers to the end via a simple if-then-else statement
  if (is.numeric(Sites) && Sites == 1){
    matt = ifelse(row_number(matt) < 10,
                  yes = paste(matt, "0", row_number(matt), sep = ""),
                  no = paste(matt, row_number(matt), sep = ""))
    row.names(matt) = NULL
    matt = data.frame(matt)
  }
  else {
    for (column in matt){
      matt[column, ] = if_else(row_number(column) < 10,
                               true = paste(column, "0", row_number(column), sep = ""),
                               false = paste(column, row_number(column), sep = ""))
    }
    row.names(matt) = NULL
    matt = matt[NSubjects+1:(nrow(matt)-NSubjects), 1]
  }
  
  for (i in (NSubjects+1)){ # +1 because it will drop off at NSubjects otherwise
    timesT = NSubjects*(RRatio/(RRatio+1))
    timesC = (NSubjects - timesT)
    TLC = data.frame(TorC = sample(t(rep(c("T", "C"), times = c(timesT, timesC)))))
  }
  # Repeat the process above for each site
  TLC = data.frame(TorC = rep(TLC$TorC, times = ifelse(is.numeric(Sites),
                                                       yes = Sites,
                                                       no = length(Sites))))
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
  
  # Turn into a dataframe:
  final <- as.data.frame(final)
  
  # Extracting different parts of the codes for easier reading:
  final["Code"] = final[, 1]
  final["Site"] =  substr(final[, 1], 1, 3) # extract first three letters from code
  final["Subject"] =  gsub("[a-zA-Z]+", "", final[, 1]) # remove letters with regex
  final["Group"] = substr(final[, 1], nchar(final[, 1]), nchar(final[, 1]))
  
  # Remove the repeated column:
  final = final %>% select(Code, Site, Subject, Group)
  
  # Return the end result:
  return(final)
}

# Unit Testing:

test1 <- schema(Sites = c("AAA"), NSubjects = 10, RRatio = 1)
test2 <- schema(Sites = 1, NSubjects = 10, RRatio = 1)
test3 <- schema(Sites = c("AAA"), NSubjects = 30, RRatio = 2)
test4 <- schema(Sites = 2, NSubjects = 30, RRatio = 2)
test5 <- schema(Sites = c("AAA", "BBB"), NSubjects = 10, RRatio = 1)
test6 <- schema(Sites = NULL, NSubjects = 10, RRatio = 1)
test7 <- schema(Sites = c("AAA", 1), NSubjects = 10, RRatio = 1)
