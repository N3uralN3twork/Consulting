setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/SF-36")
library(readxl)
library(dplyr)
library(DistributionUtils)
df <- read_excel("Practice SF-36 data.xlsx", 
                 sheet = "data")
#View(df)

data <- df

Questions <- c('Q1', 'Q2', 'Q3a', 'Q3b', 'Q3c',
             'Q3d', 'Q3e', 'Q3f', 'Q3g', 'Q3h',
             'Q3i', 'Q3j', 'Q4a', 'Q4b', 'Q4c',
             'Q4d', 'Q5a', 'Q5b', 'Q5c', 'Q6',
             'Q7', 'Q8', 'Q9a', 'Q9b', 'Q9c',
             'Q9d', 'Q9e', 'Q9f', 'Q9g', 'Q9h',
             'Q9i', 'Q10', 'Q11a', 'Q11b', 'Q11c', 'Q11d')
str(df[Questions])

# Replace negative numbers with NA
df[df < 0] <- NA

# Replace characters NA:
df[is.character(df)] <- NA

# Replace decimals with NA:











