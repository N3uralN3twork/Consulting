library(lavaan)
names(mallett)

"Incarceration Status SEM:"
JAIL <-
  "
### Latent Variables ###
EDUCATION =~ hs_grad + ged + college_degree + highest_degree +
             years_education_completed + number_grades_repeated + number_grades_skipped

DEMOGRAPHICS =~ immigrant

### Regressions ###
Incarcerated ~ EDUCATION + DEMOGRAPHICS + female + age
  "

fit <- cfa(JAIL, data=mallett, std.lv=TRUE)
summary(fit, fit.measures=TRUE, standardized=TRUE)
exp(coef(fit))





"College Status SEM:"
COLLEGE <- 
  "
### Latent Variables ###

SCHOOLDELINQUENT =~ ms_suspension + hs_suspension

DEMOGRAPHICS =~ immigrant

### Regressions ###
college_degree ~ DEMOGRAPHICS + female + age
  "

fit2 <- cfa(COLLEGE, data=mallett, std.lv=TRUE)
summary(fit2, fit.measures=TRUE, standardized=TRUE)


test <- glm(hs_grad ~ immigrant,
    data = mallett,
    family = binomial(link = "logit"))
summary(test)
exp(coef(test))

"High School Status SEM:"
HS <-
  "
### Regressions ###
hs_grad ~ immigrant + days_ms_suspension + black
  "

fit3 <- cfa(HS, data=mallett, std.lv=TRUE, group="female")
summary(fit3, fit.measures=TRUE, standardized=TRUE)
exp(coef(fit3))


test <- glm(hs_grad ~ immigrant + days_ms_suspension + black + NumSchoolsAttended,
            data = mallett,
            family = binomial(link = "logit"))
summary(test)
exp(coef(test))
confint(exp(coef(test)))


# By Gender:
gender <- glm(hs_grad ~ immigrant + days_ms_suspension + black + NumSchoolsAttended,
            data = filter(mallett, female==1),
            family = binomial(link = "logit"))
summary(gender)
exp(coef(gender))



"Income by Immigration Status:"
INCOME <- 
  "
EDUTROUBLE =~ days_hs_suspension + days_ms_suspension + hs_grad

### Regressions ###
#IncomeChange2030 ~ immigrant + female + white + hs_grad
  "

fit4 <- cfa(INCOME, data=mallett, std.lv=TRUE)
summary(fit4, fit.measures=TRUE, standardized=TRUE)
exp(coef(fit4))
