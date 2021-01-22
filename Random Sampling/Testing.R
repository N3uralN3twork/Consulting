library(dplyr)
library(ggplot2)

library(readxl)
portfolio <- read_excel("C:/Users/miqui/OneDrive/Finances/Quinn_Finances2.xlsx", 
                        sheet = "Portfolio Value")
View(portfolio)

portfolio$`Capital Invested` <- as.numeric(portfolio$`Capital Invested`)
str(portfolio)

ggplot(data = portfolio, aes(x = Date, y = "Capital Invested")) + 
  geom_bar()
