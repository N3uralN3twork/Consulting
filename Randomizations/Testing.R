"Logistic Regression Models:"
model <- glm(
  formula = AIncarceration ~ JIncarceration + Age + Victim + Divorce + Gender + Black + Hispanic + Asian + HighestGrade,
  data = Waves,
  family = binomial(link = "logit"))

model
summary(model)

# The reason for the difference between R and SAS is that R thinks that the 
# binary variables are all double-precision variables.

# Evidence:
typeof(Waves$JIncarceration)

# Change them before you continue
