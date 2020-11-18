library(gee)

names(loans)
table(loans$DelinquentBinary)

loans$FICO_Category <- factor(loans$FICO_Category, exclude = NaN)

gee1 <- gee(DelinquentBinary ~ FICO_Category + FICO_Score,
            data = loans,
            family = binomial(link = "logit"),
            corstr = "exchangeable",
            id = Account_Number)

summary(gee1)

# Get Odds coefficients:

round(exp(coef(gee1)), 5)

"Compared to customers with very low credit history, the odds of being delinquent
are 4.11 times lower for those with very good credit history."

"Both SAS and R provide the same conclusion and numbers."

a = parameterEstimates(fit4, level = 0.95)$lhs
b = parameterEstimates(fit4, level = 0.95)$op
c = parameterEstimates(fit4, level = 0.95)$rhs
d = parameterEstimates(fit4, level = 0.95)$ci.lower
e = parameterEstimates(fit4, level = 0.95)$ci.upper


result = cbind(a, b, c, exp(d), exp(e))
result























