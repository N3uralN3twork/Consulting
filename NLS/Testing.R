library(ggplot2)

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
  theme_bw() +
  theme(panel.grid.minor = element_blank()) +
  ylab("Variable") + 
  xlab("Odds Ratio") +
  ggtitle("High School Graduation Model by Various Factors\n(Odds Ratios, p-value<0.001)")