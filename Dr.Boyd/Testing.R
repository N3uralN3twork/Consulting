library(ggplot2)
library(readxl)
Calcium <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Dr.Boyd/CleanedCalcium.xlsx", 
                             sheet = "Sheet1")
View(Calcium)

names(Calcium)
str(Calcium)

Calcium$Sex <- as.factor(Calcium$Sex)
Calcium$Lab <- as.factor(Calcium$Lab)


ggplot(data = Calcium, aes(x = Sex, y = AlkPhos, fill = Sex)) +
  geom_boxplot()
ggplot(data = Calcium, aes(x = Sex, y = CamMOL, fill = Sex)) +
  geom_boxplot()
ggplot(data = Calcium, aes(x = Sex, y = PhosMOL, fill = Sex)) +
  geom_boxplot()

