"
Title: Randomization Schema
Author: Matt Quinn
Date: September 18th 2020
Finished on: October 15th 2020
Class: STA 635 Consulting and Programming
"

setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Randomization Code")


library(tidyverse) # For the unite and row_number functions
library(randomizr) # For the block_ra function
library(Randomizations)

################################################################################
###                           NOTES:                                         ###
################################################################################
# INPUT:
# A list of site codes or the number of sites you want (string/integer)
  # Up to 50 sites (26 letters + 24 Greek letters)
  # [AAA-ZZZ] => 1 <= Sites <= 26
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
schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL, seed = NULL){
  
  greeks <- list("\U03B1", "\U03B2", "\U03B3", "\U03B4", "\U03B5", "\U03B6",
                 "\U03B7", "\U03B8", "\U03B9", "\U03BA", "\U03BB", "\U03BC",
                 "\U03BD", "\U03BE", "\U03BF", "\U03C0", "\U03C1", "\U03C3",
                 "\U03C4", "\U03C5", "\U03C6", "\U03C7", "\U03C8", "\U03C9")
  
  # Define a helper function to test if input is an integer:
  check.integer <- function(N){
    !grepl("[^[:digit:]]", format(N,  digits = 20, scientific = FALSE)) # Looks for whole numbers only using regex
  }
  
  # Set the seed for reproducibility:
  if (!is.null(seed)){
    set.seed(seed)}
  
  # Input morphism:
  if (is.character(Sites)){ # If the input for sites are site prefixes
    NSites = length(Sites)  # Create a variable that tracks the number of prefixes entered
  }
  else {
    NSites = Sites
  }
  
  if (is.character(RRatio)){ # If the input is a character ratio
    nums = as.integer(unlist(str_split(string = RRatio, pattern = ":"))) # Extract the chars and turn into integers
    RRatio = nums[1]/nums[2] # Turn the above ratio into a fraction for later use
  }
  
  if (is.character(NSubjects)){ # Test if the number of subjects is a character value
    NSubjects = as.integer(NSubjects) # If it is: turn the input into an integer
  }
  
  if (is.character(BlockSize)){ # Test if the block size is a character value
    BlockSize = as.integer(BlockSize) # If it is: turn the input into an integer
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
"  test3 <- check.integer(NSubjects*(RRatio/(RRatio+1)))
  if (test3 == FALSE){
    stop('The following must be an integer: number of subjects * (RRatio/RRatio+1). Check for yourself.')
  }
  "
  if (RRatio <= 0){
    stop("The randomization ratio must be greater than 0")
  }
  
  # Improper Block Size:
  if (BlockSize>0 && NSubjects%%BlockSize != 0){
    stop("The block size must be a multiple of the number of subjects")
  }
  
  if (BlockSize%%RRatio >= 1){
    stop("Block Size and Ratio are Incompatible: cannot assign subjects with given ratio")
  }
  
  # Designing the schema:
  # If the input to sites is a NUMERIC number
  
  if (is.numeric(Sites) == TRUE & Sites >= 1 & Sites <= 26){ # Test if a numeric number
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
  else if (is.numeric(Sites) == TRUE & Sites > 26 & Sites <= 50){ # Test if a numeric number
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
    rownames(matt) = NULL
    gmatt = c() # Start with an empty vector
    for (symbol in greeks){
      result = rep(symbol, times=3)
      result = paste(result, collapse="")
      gmatt[symbol] = result
    }
    gmatt = data.frame(t(gmatt))
    gmatt = gmatt %>% uncount(NSubjects)
    colnames(gmatt) = NULL
    rownames(gmatt) = NULL
    gmatt = gmatt[1:NSubjects, 1:(Sites-26)]
    matt = cbind(matt, gmatt)
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
  
  # Assigning the Ts and Cs:
  # Start with assigning the blocks:
  vector <- c() # Initiate an empty vector
  for (i in seq(1:(NSites*(NSubjects/BlockSize)))){ # For each block
    for (j in 1:BlockSize){ # Print "BlockSize" times
      vector = append(vector, i)} # Append the results to the previously empty vector
  }
  Ts = RRatio/(RRatio+1) # Compute the proportion of Ts needed
  Cs = 1-Ts # Compute the proportion of Cs needed
  TorC = block_ra(blocks = vector, # Using the first column:
                  conditions = c("T", "C"), # 2 groups are the Ts and Cs
                  prob_each = c(Ts, Cs)) # The prob. that T or C appears
  TLC = data.frame(TorC)
  
  # Shuffle the data randomly:
  "matt = sample(matt)"
  
  # Turn the data matrix into a data.frame:
  matt = as.data.frame(matt)
  
  "# Randomizing the order of the T's and C's for each site:
  ls <- c() # Start with an empty vector
  count <- 1 # Remember, R starts at 1, not 0
  repeat { # Using the repeat function
    ls = append(ls, sample_frac(TLC, 1))
    # Shuffle the T's and C's in the block and append to the once empty vector
    count = count + 1 # Increment the count for each run of the loop by 1
    if (count > NSites){ # Stop when the count reaches the number of sites
      break # Use a break statement to exit the repeat loop, else trouble
    }
  }
  
  TLC <- data.frame(unlist(ls))" # Turn the list of lists into a single object
  
  result <- data.frame(c(matt, TLC)) # Combine TLC and matt into one dataframe
  
  # Use the "unite" function to concatenate both columns into a single column
  final <- result %>% # using the pipe operator from the dplyr syntax
    unite("Code", matt:TorC, sep = "")
  
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


test1 <- schema(Sites = "AAA", NSubjects = 10, BlockSize = 2, RRatio = "1:1", seed = FALSE)
test1
test2 <- schema(Sites = 1, NSubjects = 10, BlockSize = 2, RRatio = 1, seed = FALSE)
test2
test3 <- schema(Sites = c("AAA"), NSubjects = 30, RRatio = 2)
test4 <- schema(Sites = 2, NSubjects = 30, BlockSize = 1, RRatio = 2)
test4
test5 <- schema(Sites = c("AAA", "BBB"), NSubjects = 10, BlockSize = 1, RRatio = 1)
test6 <- schema(Sites = NULL, NSubjects = 10, BlockSize = 1, RRatio = 1) # Should return error
test7 <- schema(Sites = c("AAA", "BBB"), NSubjects = 20, BlockSize = 1, RRatio = 1, seed = FALSE)
test8 <- schema(Sites = 1, NSubjects = 50, BlockSize = 10, RRatio = 2) # Should return error
test9 <- schema(Sites =2, NSubjects = 6, BlockSize = 3, RRatio = "1:2", seed = TRUE)
test9

test10 <- schema(Sites = 30, NSubjects = 2, BlockSize = 2, RRatio = 1)
test11 <- schema(Sites = 3, NSubjects = 14, BlockSize = 7, RRatio = 4/3)
View(test10)

test <- schema(Sites=2, NSubjects=20, BlockSize=10, RRatio="1:1", seed=FALSE)

max(rle(test11$Group)$lengths)












