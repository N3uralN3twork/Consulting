sqrt <- function(a, init, eps = 0.01, iter = 100){
  stopifnot(a >= 0)
  i <- 1
  while(abs(init**2 - a) > eps){
    init <- 1/2 *(init + a/init)
    i <- i + 1
    if(i > iter) stop("Maximum number of iterations reached")
  }
  return(init)
}