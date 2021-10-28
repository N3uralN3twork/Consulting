library(stats)

data = X_iris
method = "complete"
max.nc = 5
min.nc = 2
diss = NULL
index = "all"
distance = "euclidean"
min_nc <- min.nc
max_nc <- max.nc
if (is.null(method)) 
  stop("method is NULL")
method <- pmatch(method, c("ward.D2", "single", "complete", 
                           "average", "mcquitty", "median", "centroid", "kmeans", 
                           "ward.D"))
indice <- pmatch(index, c("kl", "ch", "hartigan", "ccc", 
                          "scott", "marriot", "trcovw", "tracew", "friedman", 
                          "rubin", "cindex", "db", "silhouette", "duda", "pseudot2", 
                          "beale", "ratkowsky", "ball", "ptbiserial", "gap", "frey", 
                          "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", 
                          "sdindex", "dindex", "sdbw", "all", "alllong"))

df <- data.frame(V1 = seq(1, 10),
                 V2 = c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1),
                 V3 = seq(10, 19))
labels = c(1, 1, 1, 1, 2, 2, 2, 2, 3, 3)

jeu1 <- as.matrix(data)
numberObsBefore <- dim(jeu1)[1]
jeu <- na.omit(jeu1)
nn <- dim(jeu)[1]
pp <- dim(jeu)[2]
TT <- t(jeu) %*% jeu
sizeEigenTT <- length(eigen(TT)$value)
eigenValues <- eigen(TT/(nn - 1))$value

if (any(indice == 4) || (indice == 5) || (indice ==6) || (indice == 7) ||
    (indice == 8) || (indice == 9) || (indice == 10) || (indice == 31) ||
    (indice == 32)) {
  for (i in 1:sizeEigenTT) {
    if (eigenValues[i] < 0) {
      stop("The TSS matrix is indefinite. There must be too many missing values. The index cannot be calculated.")
    }
  }
  s1 <- sqrt(eigenValues)
  ss <- rep(1, sizeEigenTT)
  for (i in 1:sizeEigenTT) {
    if (s1[i] != 0) 
      ss[i] = s1[i]
  }
  vv <- prod(ss)
}



if (is.null(distance)) 
  distanceM <- 7
if (!is.null(distance)) 
  distanceM <- pmatch(distance, c("euclidean", "maximum", 
                                  "manhattan", "canberra", "binary", "minkowski"))
if (is.na(distanceM)) {
  stop("invalid distance")
}
if (is.null(diss)) {
  if (distanceM == 1) {
    md <- dist(jeu, method = "euclidean")
  }
  if (distanceM == 2) {
    md <- dist(jeu, method = "maximum")
  }
  if (distanceM == 3) {
    md <- dist(jeu, method = "manhattan")
  }
  if (distanceM == 4) {
    md <- dist(jeu, method = "canberra")
  }
  if (distanceM == 5) {
    md <- dist(jeu, method = "binary")
  }
  if (distanceM == 6) {
    md <- dist(jeu, method = "minkowski")
  }
  if (distanceM == 7) {
    stop("dissimilarity matrix and distance are both NULL")
  }
}
if (!is.null(diss)) {
  if ((distanceM == 1) || (distanceM == 2) || (distanceM ==  3) ||
      (distanceM == 4) || (distanceM == 5) || (distanceM == 6)) 
    stop("dissimilarity matrix and distance are both not null")
  else md <- diss
}

res <- array(0, c(max_nc - min_nc + 1, 30))
x_axis <- min_nc:max_nc
resCritical <- array(0, c(max_nc - min_nc + 1, 4))
rownames(resCritical) <- min_nc:max_nc
colnames(resCritical) <- c("CritValue_Duda", "CritValue_PseudoT2", 
                           "Fvalue_Beale", "CritValue_Gap")
rownames(res) <- min_nc:max_nc
colnames(res) <- c("KL", "CH", "Hartigan", "CCC", "Scott", 
                   "Marriot", "TrCovW", "TraceW", "Friedman", "Rubin", 
                   "Cindex", "DB", "Silhouette", "Duda", "Pseudot2", "Beale", 
                   "Ratkowsky", "Ball", "Ptbiserial", "Gap", "Frey", "McClain", 
                   "Gamma", "Gplus", "Tau", "Dunn", "Hubert", "SDindex", 
                   "Dindex", "SDbw")


if (is.na(method)) 
  stop("invalid clustering method")
if (method == -1) 
  stop("ambiguous method")
if (method == 1) {
  hc <- hclust(md, method = "ward.D2")
}
if (method == 2) {
  hc <- hclust(md, method = "single")
}
if (method == 3) {
  hc <- hclust(md, method = "complete")
}
if (method == 4) {
  hc <- hclust(md, method = "average")
}
if (method == 5) {
  hc <- hclust(md, method = "mcquitty")
}
if (method == 6) {
  hc <- hclust(md, method = "median")
}
if (method == 7) {
  hc <- hclust(md, method = "centroid")
}
if (method == 9) {
  hc <- hclust(md, method = "ward.D")
}

centers <- function(cl, x) {
  x <- as.matrix(x)
  n <- length(cl)
  k <- max(cl)
  centers <- matrix(nrow = k, ncol = ncol(x))
  {
    for (i in 1:k) {
      for (j in 1:ncol(x)) {
        centers[i, j] <- mean(x[cl == i, j])
      }
    }
  }
  return(centers)
}

centroids = centers(1:3, data)
print(centroids)

Index.sPlussMoins <- function (cl1, md)
{
  cn1 <- max(cl1)
  n1 <- length(cl1)
  dmat <- as.matrix(md)
  average.distance <- median.distance <- separation <- cluster.size <- within.dist1 <- between.dist1 <- numeric(0)
  separation.matrix <- matrix(0, ncol = cn1, nrow = cn1)
  di <- list()
  for (u in 1:cn1) {
    cluster.size[u] <- sum(cl1 == u)
    du <- as.dist(dmat[cl1 == u, cl1 == u])
    within.dist1 <- c(within.dist1, du)
    average.distance[u] <- mean(du)
    median.distance[u] <- median(du)
    bv <- numeric(0)
    for (v in 1:cn1) {
      if (v != u) {
        suv <- dmat[cl1 == u, cl1 == v]
        bv <- c(bv, suv)
        if (u < v) {
          separation.matrix[u, v] <- separation.matrix[v,u] <- min(suv)
          between.dist1 <- c(between.dist1, suv)
        }
      }
    }
  }
  
  nwithin1 <- length(within.dist1)
  nbetween1 <- length(between.dist1)
  meanwithin1 <- mean(within.dist1)
  meanbetween1 <- mean(between.dist1)
  
  s.plus <- s.moins <- 0 
  for (k in 1: nwithin1)
  {
    s.plus <- s.plus+(colSums(outer(between.dist1,within.dist1[k], ">")))
    s.moins <- s.moins+(colSums(outer(between.dist1,within.dist1[k], "<")))
  }    
  
  Index.Gamma <- (s.plus-s.moins)/(s.plus+s.moins)
  Index.Gplus <- (2*s.moins)/(n1*(n1-1))
  t.tau  <- (nwithin1*nbetween1)-(s.plus+s.moins)
  Index.Tau <- (s.plus-s.moins)/(((n1*(n1-1)/2-t.tau)*(n1*(n1-1)/2))^(1/2))
  
  results <- list(gamma=Index.Gamma, gplus=Index.Gplus, tau=Index.Tau)
  return(results)
}







set.seed(10)
x = rnorm(n=100, mean=5, sd=3)
library(nortest)
ad.test(x)
matrix(x, nrow = 100)
