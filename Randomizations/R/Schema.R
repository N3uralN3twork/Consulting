#' @title Create a Random Design Schema
#'
#' @description This function creates a completely randomized design of experiments
#' design schema in the form of a data.frame. It assumes that you know
#' what the various inputs of designing a randomization schema are.
#'
#' @param Sites A number of sites / a list of site codes to be used
#' @param NSubjects The number of subjects assigned to each site
#' @param BlockSize The number of subjects assigned to each block
#' @param RRatio The randomization ratio used to assign treatment and control groups
#' @param seed The seed set for reproducibility
#'
#' @return A dataframe containing the design matrix
#'
#' @author Matthias Quinn <miq_qedquinn@@yahoo.com>
#'
#' @section Warning:
#' Please don't use this function outside of the classroom
#'
#' @import tidyverse dplyr randomizr
#'
#' @export
schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL, seed = FALSE){

  # Define a helper function to test if input is an integer:
  check.integer <- function(N){
    !grepl("[^[:digit:]]", format(N,  digits = 20, scientific = FALSE)) # Looks for whole numbers only using regex
  }

  # Set the seed for reproducibility:
  if (seed == TRUE){
    set.seed(123)}

  # Input morphism:
  if (is.character(Sites)){ # If the input for sites are site prefixes
    NSites = length(Sites)  # Create a variable that tracks the number of prefixes entered
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
  test3 <- check.integer(NSubjects*(RRatio/(RRatio+1)))
  if (test3 == FALSE){
    stop("The following must be an integer: number of subjects * (RRatio/RRatio+1). Check for yourself.")
  }

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

  # Assigning the Ts and Cs:
  # Start with assigning the blocks:
  vector <- c() # Initiate an empty vector
  for (i in seq(1:(NSubjects/BlockSize))){ # For each block
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

  ls <- c()
  count <- 1
  repeat {
    ls = append(ls, sample_frac(TLC, 1))
    count = count + 1
    if (count > NSites){
      break
    }
  }

  TLC <- data.frame(unlist(ls))

  result <- data.frame(c(matt, TLC))

  # Use the "unite" function to concatenate both columns into a single column
  final <- result %>% # using the pipe operator from the dplyr syntax
    unite(result, c("matt", "unlist.ls."), sep = "")

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
