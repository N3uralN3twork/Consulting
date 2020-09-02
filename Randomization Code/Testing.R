library(gmodels)

table(is.na(child$SDQ))
CrossTable(child$SDQ, format = "SPSS")
