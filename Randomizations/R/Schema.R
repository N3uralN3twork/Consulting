#' @title Create a Random Design Schema
#'
#' @description This function creates a completely randomized design of experiments
#' design schema in the form of a data.frame. It assumes that you know
#' what the various inputs of a designing a randomization schema are.
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
#' @import tidyverse dplyr
#'
#' @export
schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL, seed = TRUE){

  # Set the seed for reproducibility:
  if (seed == TRUE){
    set.seed(123)}

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
    stop("The randomization ratio must adhere to NSubjects*(RRatio/RRatio+1)%%1 = 0")
  }

  if (RRatio <= 0){
    stop("The randomization ratio must be greater than 0")
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
    matt = data.frame(t(matt)) # Transpose "matt"
    matt = matt %>% # For each site code in your input:
      uncount(NSubjects) # Duplicate the site code NSubjects number of times
    matt = matt[1:NSubjects, 1:Sites] # Removing redundent codes
    rownames(matt) = NULL
  }
  # If the input to sites is a CHARACTER vector
  else if (is.vector(Sites) == TRUE){
    matt = matrix(NA, nrow = length(Sites), ncol = NSubjects)
    dimnames(matt) = list(Sites)
    final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = 1)
    for (i in Sites){
      for (j in NSubjects){
        matt[i, ] = rep(i, times = NSubjects) # Row-wise assignment
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
