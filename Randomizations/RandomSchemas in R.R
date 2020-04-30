library(dplyr)
library(readr)
library(ISLR)
library(datasets)
library(randomizeR)



data(College)

train3 <- sample_frac(tbl = College, size = 0.5, replace = FALSE, set.seed(123))
train4 <- sample_frac(tbl = College, size = 0.5, replace = FALSE, set.seed(123))
identical(train3, train4)
#Should be TRUE

randomizeR::pbrPar()

random <- function(dataset, sample_size = nrow(dataset)){
            sample_n(dataset, sample_size)}


test = pbrPar(rep(4, 6))


