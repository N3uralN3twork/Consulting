"
Title: Randomization Schema
Author: Matt Quinn
Date: September 8th 2020
Finished on: September 11th 2020
Class: STA 635 Consulting and Programming
"

setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Randomization Code")

# install.packages("tidyverse")
library(tidyverse) # For the unite and row_number functions

################################################################################
###                           NOTES:                                         ###
################################################################################
# INPUT:
  # A list of site codes or the number of sites you want (string/integer)
  # The number of subjects per site (integer)
  # The number of subjects per block
  # The randomization ratio
  # The seed for reproducibility

# OUTPUT:
  # A sequential list of N codes inside a dataframe object
  # The site codes
  # Subject ID numbers
  # The group each subject belongs to

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

# Seed:
  # Do you want to reproduce the design schema?

# Block Sizes:
  # Must be a multiple of the number of sites
  # Number of blocks = NSubjects / block size

##################################
###    SCHEMA for N Site(s)    ###
##################################

schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL, seed = TRUE){
  
  # Set the seed for reproducibility:
  if (seed == TRUE){
    set.seed(123)}
  
  # Input morphism:
  if (is.character(RRatio)){ # If the input is a character ratio
    nums = as.integer(unlist(str_split(string = RRatio, pattern = ":"))) # Extract the chars and turn into integers
    RRatio = nums[1]/nums[2] # Turn the above ratio into a fraction for later use
  }
  
  if (is.character(NSubjects)){
    NSubjects = as.integer(NSubjects)
  }
  
  if (is.character(BlockSize)){
    BlockSize = as.integer(BlockSize)
  }
  
  NBlocks = NSubjects/BlockSize # Compute the number of blocks
  
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
  test3 <- NSubjects*(RRatio/(RRatio+1))%%1 == 0
  if (test3 == TRUE){
    stop("The randomization ratio must adhere to NSubjects*(RRatio/RRatio+1)%%1 = 0")
  }
  
  if (RRatio <= 0){
    stop("The randomization ratio must be greater than 0")
  }
  
  # Improper Block Size:
  if (BlockSize>0 && NSubjects%%BlockSize != 0){
    stop("The block size must be a multiple of the number of subjects")
  }
  
  # Improper random seed
  "%!in%" = Negate("%in%") # Handy function to include the negation of an IN statement
  
  if (seed %!in% c(TRUE, FALSE)){ # If seed not TRUE or FALSE:
    stop("The seed should be a boolean input") # Return this error message
  }
  
  # Designing the schema:
  # If the input to sites is a NUMERIC number
  if (is.numeric(Sites) == TRUE){ # Test if a numeric number
    matt = c() # Start with an empty vector
    final = matrix(NA, nrow = Sites*NSubjects, ncol = 1) # Add an empty matrix
    for (letter in LETTERS){ # For each letter in the uppercase(Alphabet):
      result = rep(letter, times = 3) # Repeat each letter 3 times
      result = paste(result, collapse = "") # Combine the result into 1 string
      matt[letter] = result # Assigns the result to the previously empty vector "matt"
    } # Now that we have assigned the letters to the vector "matt"
    matt = data.frame(t(matt)) # Transpose the vector
    matt = matt %>% # For each site code in your input:
      uncount(NSubjects) # Duplicate the site code NSubjects number of times
    matt = matt[1:NSubjects, 1:Sites] # Removing redundant codes
    rownames(matt) = NULL # Aesthetics
  }
  # If the input to sites is a CHARACTER vector
  else if (is.vector(Sites) == TRUE){
    matt = matrix(NA, nrow = length(Sites), ncol = NSubjects)  # Start with an empty data matrix
    dimnames(matt) = list(Sites) # Must include or won't run
    final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = 1) # Start with an empty data matrix
    for (i in Sites){ # For each site:
      for (j in NSubjects){ # And for each subject
        matt[i, ] = rep(i, times = NSubjects) # Row-wise assignment of letters
      }
    }
    matt = as.data.frame(t(matt)) # Transpose and turn into a dataframe for reasonable viewing
    rownames(matt) = NULL # Replace unnecessary rownames
    matt = data.frame(matt)
  }
  # Adding the numbers to the end via a simple if-then-else statement
  if (is.numeric(Sites) && Sites == 1){
    matt = ifelse(row_number(matt) < 10, # If the row-number is less than 10:
                  yes = paste(matt, "0", row_number(matt), sep = ""), # Assign a 0 between letter and number
                  no = paste(matt, row_number(matt), sep = "")) # Otherwise: assign no space between letters and number
    row.names(matt) = NULL
    matt = data.frame(matt)
  }
  else { # For all other cases:
    for (column in matt){ # For each column in the "matt" matrix
      matt[column, ] = if_else(row_number(column) < 10, # Same instructions as above
                               true = paste(column, "0", row_number(column), sep = ""),
                               false = paste(column, row_number(column), sep = ""))
    }
    row.names(matt) = NULL
    matt = matt[NSubjects+1:(nrow(matt)-NSubjects), 1] # Only keep the first column and a subset of rows
  }
  
  for (i in (NSubjects+1)){ # +1 because it will drop off at NSubjects otherwise
    timesT = NSubjects*(RRatio/(RRatio+1)) # Calculates the number of Ts to assign
    timesC = (NSubjects - timesT) # Calculates the number of Cs to assign
    TLC = data.frame(TorC = sample(t(rep(c("T", "C"), times = c(timesT, timesC))))) # Concatenates and puts into a dataframe
  }
  # Repeat the process above for each site
  # Must assign special cases for 1 dimensional and N>1 dimensional matrices
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
  
  # Remove the repetitive column:
  final = final %>% select(Code, Site, Subject, Group) # Using dplyr's built-in pipe (%>%) operator
  
  # Return the end result:
  return(final)
}

# Unit Testing:

test1 <- schema(Sites = c("AAA"), NSubjects = 10, BlockSize = 1, RRatio = "1:1", seed = TRUE)
test2 <- schema(Sites = 1, NSubjects = 10, BlockSize = 1, RRatio = 1)
test3 <- schema(Sites = c("AAA"), NSubjects = 30, RRatio = 2)
test4 <- schema(Sites = 2, NSubjects = 30, BlockSize = 1, RRatio = 2)
test5 <- schema(Sites = c("AAA", "BBB"), NSubjects = 10, BlockSize = 1, RRatio = 1)
test6 <- schema(Sites = NULL, NSubjects = 10, BlockSize = 1, RRatio = 1) # Should return error
test7 <- schema(Sites = c("AAA", "BBB"), NSubjects = 20, BlockSize = 1, RRatio = 1, seed = FALSE)
