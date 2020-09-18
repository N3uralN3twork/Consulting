library(ggplot2)
library(readxl)
calcium <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Dr.Boyd/CalciumGood.xlsx", 
                      sheet = "Sheet1")
View(calcium)

names(calcium)

calcium$SEX <- as.factor(calcium$SEX)

ggplot(data = calcium, aes(x = SEX, y = ALKPHOS, fill = SEX)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Comparison of Alkaline Phosphate (IU/L) by Gender") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(x = "Gender", y = "Alkaline Phosphate (IU/L)")
