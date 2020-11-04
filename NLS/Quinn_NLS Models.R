library(lavaan)
library(lavaanPlot)
library(semPlot)
library(DiagrammeR)
library(rpart)
library(rpart.plot)
library(C50)
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

HS2 <-
  "
### Latent Variables ###
TRAUMA =~ VictViolentCrime + Homeless + HHHospital + HHJail
  
EDUTROUBLE =~ days_ms_suspension + days_hs_suspension
  
### Regressions ###
hs_grad ~ TRAUMA + EDUTROUBLE + immigrant + black + female + ever_in_gang
  "

fit3 <- cfa(HS2, data=clean, std.lv=TRUE)
summary(fit3, fit.measures=TRUE, standardized=TRUE)
exp(coef(fit3))


"High School Graduate SEM:"
HS <-
  "
### Latent Variables ###
TRAUMA =~ VictViolentCrime + Homeless + HHHospital + HHJail

DELINQUENCY =~ ever_in_gang + EverSmoke + EverArrested
  
  
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






# Plotting the Odds Ratios and 95% CIs:
library(ggplot2)
library(ggthemes)

exp(cbind("Odds ratio" = coef(fit3), confint.default(fit3, level = 0.95)))

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


mermaid("
graph TB
A[Immigrant] --0.998 --> N[HS Graduate]
B[Black] --0.927 --> N[HS Graduate]
C[Female] --1.047 --> N[HS Graduate]
D[MS Suspend] --0.998 --> N[HS Graduate]
E[Gang Member] --0.280 --> L((Delinquency))
F[EverSmoke] --1.253 --> L((Delinquency))
G[EverArrested] --1.145 --> L((Delinquency))
H[VictViolent Crime] --0.268 --> M((Trauma))
I[Homeless] --0.289 --> M((Trauma))
J[HHHospital] --0.118 --> M((Trauma))
K[HHJail] --0.280 --> M((Trauma))
L((Delinquency)) --0.979 --> N[HS Graduate]
M((Trauma)) --0.903 --> N[HS Graduate]
        ")

# Plotting one of the Decision Trees:
grViz("
      digraph Tree {
      node [shape=box, style='filled, rounded', color='black', fontname=helvetica] ;
      edge [fontname=helvetica] ;
      0 [label=<days_ms_suspension &le; 2.5<br/>gini = 0.345<br/>samples = 4556<br/>value = [1592, 5580]<br/>class = Graduate>, fillcolor='#71b9ec'] ;
      1 [label=<NumSchoolsAttended &le; 2.348<br/>gini = 0.27<br/>samples = 3583<br/>value = [910, 4737]<br/>class = Graduate>, fillcolor='#5fb0ea'] ;
      0 -> 1 [labeldistance=2.5, labelangle=45, headlabel='True'] ;
      2 [label=<ever_in_gang &le; 0.532<br/>gini = 0.203<br/>samples = 2416<br/>value = [432, 3328]<br/>class = Graduate>, fillcolor='#53aae8'] ;
      1 -> 2 ;
      3 [label=<gini = 0.2<br/>samples = 2371<br/>value = [415, 3273]<br/>class = Graduate>, fillcolor='#52a9e8'] ;
      2 -> 3 ;
      4 [label=<gini = 0.361<br/>samples = 45<br/>value = [17, 55]<br/>class = Graduate>, fillcolor='#76bbed'] ;
      2 -> 4 ;
      5 [label=<VictViolentCrime &le; 0.062<br/>gini = 0.378<br/>samples = 1167<br/>value = [478, 1409]<br/>class = Graduate>, fillcolor='#7cbeee'] ;
      1 -> 5 ;
      6 [label=<gini = 0.358<br/>samples = 912<br/>value = [346, 1134]<br/>class = Graduate>, fillcolor='#75bbed'] ;
      5 -> 6 ;
      7 [label=<gini = 0.438<br/>samples = 255<br/>value = [132, 275]<br/>class = Graduate>, fillcolor='#98ccf1'] ;
      5 -> 7 ;
      8 [label=<NumSchoolsAttended &le; 3.054<br/>gini = 0.494<br/>samples = 973<br/>value = [682, 843]<br/>class = Graduate>, fillcolor='#d9ecfa'] ;
      0 -> 8 [labeldistance=2.5, labelangle=-45, headlabel='False'] ;
      9 [label=<days_ms_suspension &le; 12.5<br/>gini = 0.485<br/>samples = 753<br/>value = [492, 701]<br/>class = Graduate>, fillcolor='#c4e2f7'] ;
      8 -> 9 ;
      10 [label=<gini = 0.457<br/>samples = 481<br/>value = [272, 499]<br/>class = Graduate>, fillcolor='#a5d2f3'] ;
      9 -> 10 ;
      11 [label=<gini = 0.499<br/>samples = 272<br/>value = [220, 202]<br/>class = Non-graduate>, fillcolor='#fdf5ef'] ;
      9 -> 11 ;
      12 [label=<NumSchoolsAttended &le; 3.28<br/>gini = 0.49<br/>samples = 220<br/>value = [190, 142]<br/>class = Non-graduate>, fillcolor='#f8dfcd'] ;
      8 -> 12 ;
      13 [label=<gini = 0.0<br/>samples = 4<br/>value = [8, 0]<br/>class = Non-graduate>, fillcolor='#e58139'] ;
      12 -> 13 ;
      14 [label=<gini = 0.492<br/>samples = 216<br/>value = [182, 142]<br/>class = Non-graduate>, fillcolor='#f9e3d3'] ;
      12 -> 14 ;
      }")

# Decision Trees:
tree <- rpart(hs_grad ~ days_ms_suspension + NumSchoolsAttended + HHJail + Homeless + ever_in_gang + 
                VictViolentCrime + female + HHHospital + black + immigrant,
              data = clean,
              split = "information")

summary(tree)

rpart.plot(tree, box.palette="RdBu", shadow.col = "gray", nn=TRUE)


tree2 <- C5.0(as.factor(hs_grad) ~ days_ms_suspension + NumSchoolsAttended + HHJail + Homeless + ever_in_gang + 
                VictViolentCrime + female + HHHospital + black + immigrant,
              data = clean)
plot(tree2, subtree = 1)
