library(readxl)
vector <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Dr.Boyd/vector.xlsx")
View(vector)

vector <- as.matrix(vector)

test <- as.data.frame(matrix(vector, ncol = 8, byrow = T))

# For a discrete random variable:
plot(ecdf(iris$Species))

# For a continuous random variable:
plot(ecdf(iris$Sepal.Length))
