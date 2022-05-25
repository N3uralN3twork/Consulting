"yPaths <- .libPaths()
myPaths <- c('C:/Users/miqui/Documents', myPaths)
.libPaths(myPaths)"

library(tidyverse)

Sites <- 2
NSubjects <- 10
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
print(matt)
