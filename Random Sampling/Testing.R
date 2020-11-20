"""
Moosavi, Sobhan, Mohammad Hossein Samavatian, Srinivasan Parthasarathy, and Rajiv Ramnath. "A Countrywide Traffic Accident Dataset.", 2019.
"""
setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Random Sampling")
library(readr)
#accidents <- read_csv("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Random Sampling/archive/US_Accidents_June20.csv")
View(accidents)

library(dplyr)
library(lubridate)
names(accidents)

accidents$Month <- month(accidents$Start_Time)
accidents$Year <- year(accidents$Start_Time)

table(accidents$Month)
table(accidents$Year)

df <- accidents %>% filter(Month %in% c(5, 6, 7),
                           Year == 2020) # Summer months in 2020



