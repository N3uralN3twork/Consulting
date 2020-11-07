library(MLeval)



res <- evalm(glm, gnames = c("glm"))

resamps <- resamples(list(GLM = glm,
                          RF = rf,
                          ))