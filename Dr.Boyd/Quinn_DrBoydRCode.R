"Import the libraries and data:"
library(ggplot2)
library(readxl)
library(dplyr)
calcium <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Dr.Boyd/CalciumGood.xlsx", 
                      sheet = "Data")
View(calcium)

names(calcium)

"Change the SEX variable to a factor:"
calcium$SEX <- as.factor(calcium$SEX)
calcium <- as.data.frame(calcium)
calcium <- calcium %>%
  mutate(SEX = recode(SEX,
                      `1`="Male",
                      `2`="Female"))

table(calcium$LAB)
table(calcium$AGEGROUP)

  
ggplot(data = calcium, aes(x = SEX, y = ALKPHOS, fill = SEX)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Comparison of Alkaline Phosphate (IU/L) by Gender") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(x = "Gender", y = "Alkaline Phosphate (IU/L)")



