plot(ecdf(iris$Sepal.Length))

data <- data.frame(X=c(1,2,3,4), Px=c(0.12,0.18,0.28,0.42))
plot(ecdf(data$Px))
