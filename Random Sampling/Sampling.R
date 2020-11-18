library(dplyr)

data('iris')

# Take a simple random sample with replacement:
set.seed(1234)
test <- sample_n(iris, size = 10, replace = TRUE)

# Take a simple random sample without replacement:
set.seed(1234)
test2 <- sample_n(iris, size = 10, replace = FALSE)

# Taking a systematic random sample:
sys.sample <- function(df, n, N, initial=F){
  k <- floor(N/n)
  if(initial==F){
    initial <- sample(1:k, 1)}
  cat("Interval=", k, " Starting value=", initial, "\n")
  # Put the origin in the value 'initial'
  shift <- (1:N) - initial
  # I search numbers who are multiple of number k
  # (equivalent to find the rest of a%%b=0)
  guy <- (1:N)[(shift %% k) == 0]
  result <- df[guy, ]
  return(result)
}

test3 <- sys.sample(iris, 5, 100, initial = FALSE)


# Taking a stratified random sample:
set.seed(1234)
test4 <- iris %>%
          group_by(Species) %>%
          sample_n(size = 10)

# Taking a cluster random sample:
set.seed(1234)
