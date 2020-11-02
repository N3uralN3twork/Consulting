library(lavaan)
library(lavaanPlot)
library(semPlot)
library(DiagrammeR)
names(clean)

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

fit <- cfa(JAIL, data=clean, std.lv=TRUE)
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

fit2 <- cfa(COLLEGE, data=clean, std.lv=TRUE)
summary(fit2, fit.measures=TRUE, standardized=TRUE)


test <- glm(hs_grad ~ immigrant,
    data = mallett,
    family = binomial(link = "logit"))
summary(test)
exp(coef(test))





"High School Graduate SEM:"
HS <-
  "
### Latent Variables ###
TRAUMA =~ VictViolentCrime + Homeless + HHHospital + HHJail

DELINQUENCY =~ ever_in_gang
  
  
### Regressions ###
hs_grad ~ TRAUMA + DELINQUENCY + immigrant + days_ms_suspension + black + female
  "

fit3 <- cfa(HS, data=clean, std.lv=TRUE)
summary(fit3, fit.measures=TRUE, standardized=TRUE)
exp(coef(fit3))

"Plotting the High School Model:"
lavaanPlot(model = fit3, coef=TRUE)

semPaths(object=fit3, whatLabels = "std",
         intercepts = FALSE, layout = "tree",
         style = "lisrel", optimizeLatRes = TRUE)



library(ggplot2)
library(ggthemes)

exp(cbind("Odds ratio" = coef(test), confint.default(test, level = 0.95)))

boxLabels = c("Immigrant", "Days MS Suspension", "Black", "Schools Attended")

# Create the dataframe of results:
df <- data.frame(yAxis = length(boxLabels):1, 
                 boxOdds = c(0.7264, 0.9714, 0.6866, 0.7648), 
                 boxCILow = c(0.6199, 0.9672, 0.6071, 0.7280), 
                 boxCIHigh = c(0.8511, 0.9756, 0.7766, 0.8033))

# Create the Odds Ratio plot:
ggplot(df, aes(x = boxOdds, y = boxLabels)) +
  geom_point(color = "orange", size = 3.5) +
  geom_vline(aes(xintercept = 1), size = 0.25, linetype = "dashed") +
  geom_errorbarh(aes(xmax = boxCIHigh, xmin = boxCILow), size = 0.5, color = "gray50") +
  geom_text(aes(label = boxOdds), vjust = -3) +
  theme_economist() +
  theme(panel.grid.minor = element_blank()) +
  ylab("Variable") + 
  xlab("Odds Ratio") +
  ggtitle("High School Graduation Model by Various Factors\n(Odds Ratios, p-value<0.001, CI=95%)")






test <- glm(hs_grad ~ immigrant + days_ms_suspension + black + NumSchoolsAttended + female,
            data = clean,
            family = binomial(link = "logit"))
summary(test)
exp(coef(test))
confint(exp(coef(test)))


# By Gender:
gender <- glm(hs_grad ~ immigrant + days_ms_suspension + black + NumSchoolsAttended,
            data = filter(clean, female==1),
            family = binomial(link = "logit"))
summary(gender)
exp(coef(gender))




#### GRAPHING ####

library(DiagrammeR)
# (()) = circle
# {} = rhombus
# 

mermaid("
graph LR
A[Immigrant] -- 0.998 --> K[HS Graduate]
B((Trauma)) -- 0.2 --> K[HS Graduate]
C((HS Trouble)) -- 0.3 --> K[HS Graduate]
D((Delinquency)) -- 0.4 --> K[HS Graduate]
E((Crime)) -- 0.5 --> K[HS Graduate]
A -- 0.60 --> C
B -- 0.70 --> C
D -- 0.80 --> C
")

mermaid("
graph LR
A[Immigrant] --0.998 --> L[HS Graduate]
B[Black] --0.927 --> L[HS Graduate]
C[Female] --1.047 --> L[HS Graduate]
D[MS Suspend] --0.998 --> L[HS Graduate]
E[Gang Member] --0.280 --> J((Delinquent))
F[Violent Crime] --0.268 --> K((Trauma))
G[Homeless] --0.289 --> K((Trauma))
H[HHHospital] --0.118 --> K((Trauma))
I[HHJail] --0.280 --> K((Trauma))
J((Delinquent)) --0.979 --> L[HS Graduate]
K((Trauma)) --0.903 --> L[HS Graduate]
        ")













