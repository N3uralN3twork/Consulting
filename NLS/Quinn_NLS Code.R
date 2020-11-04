"""
Author: Matthias Quinn
Date Began: 22nd October 2020
Class: Statistical Consulting
Sources:
  https://rpubs.com/sskrupan/convertmultiplevariables
  https://www.bls.gov/data/inflation_calculator.htm
"""
setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/NLS")
library(readr)
library(ggplot2)
library(dplyr)
mallett <- read_csv("C:/Users/miqui/OneDrive/CSU Classes/Consulting/NLS/mallett.csv")
View(mallett)



"EDA:"
table(mallett$age_first_incarcerated)
# SAT = highest SAT Math score as of 2007

table(mallett$ever_in_gang)
# D, I, R: Should be treated as missing

# Age:
summary(mallett$age)
table(mallett$age)


ggplot(data = mallett, aes(x=age)) +
  geom_histogram()

# Income:
summary(mallett$income2017)
table(mallett$income1996)

summary(mallett$assets_20)
table(mallett$assets_20)

"Adjusting income/assets/debts for inflation:"
# Get a list of the income variables:
grep("^[income]", names(mallett), value = TRUE) # Via regex language

# Missing data for years 2011, 2013, 2015
incomes <- list(mallett$income1996, mallett$income1997, mallett$income1998, mallett$income1999,
                mallett$income2000, mallett$income2001, mallett$income2002, mallett$income2003,
                mallett$income2004, mallett$income2005, mallett$income2006, mallett$income2007,
                mallett$income2008, mallett$income2009, mallett$income2010, mallett$income2012,
                mallett$income2014, mallett$income2016, mallett$income2017)

lapply(incomes, table)

# Set D, N, I, R values to missing:
  # 2017 has only has I values
mallett <- mallett %>%
  mutate(income1996IA = replace(income1996, income1996 %in% c(NA, "D", "R"), NA)) %>%
  mutate(income1997IA = replace(income1997, income1997 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income1998IA = replace(income1998, income1998 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income1999IA = replace(income1999, income1999 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2000IA = replace(income2000, income2000 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2001IA = replace(income2001, income2001 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2002IA = replace(income2002, income2002 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2003IA = replace(income2003, income2003 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2004IA = replace(income2004, income2004 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2005IA = replace(income2005, income2005 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2006IA = replace(income2006, income2006 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2007IA = replace(income2007, income2007 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2008IA = replace(income2008, income2008 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2009IA = replace(income2009, income2009 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2010IA = replace(income2010, income2010 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2012IA = replace(income2012, income2012 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2014IA = replace(income2014, income2014 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2016IA = replace(income2016, income2016 %in% c(NA, "D", "N", "R"), NA)) %>%
  mutate(income2017IA = replace(income2017, income2017 %in% c(NA, "D", "I", "N", "R"), NA))

# Convert the newly made variables into the numeric data type:
new_income <- c("income1996IA", "income1997IA", "income1998IA", "income1999IA",
                "income2000IA", "income2001IA", "income2002IA", "income2003IA",
                "income2004IA", "income2005IA", "income2006IA", "income2007IA",
                "income2008IA", "income2009IA", "income2010IA", "income2012IA",
                "income2014IA", "income2016IA", "income2017IA")
mallett[ ,new_income] <- lapply(mallett[ ,new_income], as.numeric)
summary(mallett[ ,new_income])

# Adjusting the incomes into 2020 $'s:
mallett <- mallett %>%
  mutate(income1996IA = income1996IA*1.64) %>%
  mutate(income1997IA = income1997IA*1.61) %>%
  mutate(income1998IA = income1998IA*1.59) %>%
  mutate(income1999IA = income1999IA*1.55) %>%
  mutate(income2000IA = income2000IA*1.50) %>%
  mutate(income2001IA = income2001IA*1.47) %>%
  mutate(income2002IA = income2002IA*1.44) %>%
  mutate(income2003IA = income2003IA*1.41) %>%
  mutate(income2004IA = income2004IA*1.37) %>%
  mutate(income2005IA = income2005IA*1.32) %>%
  mutate(income2006IA = income2006IA*1.31) %>%
  mutate(income2007IA = income2007IA*1.29) %>%
  mutate(income2008IA = income2008IA*1.23) %>%
  mutate(income2009IA = income2009IA*1.23) %>%
  mutate(income2010IA = income2010IA*1.20) %>%
  mutate(income2012IA = income2012IA*1.15) %>%
  mutate(income2014IA = income2014IA*1.11) %>%
  mutate(income2016IA = income2016IA*1.10) %>%
  mutate(income2017IA = income2017IA*1.07) # 2017 is NA

#Analyzing Incomes over Time:
summary(mallett$income1996IA)
summary(mallett$income2016IA)
t.test(mallett$income2016IA, mallett$income1996IA)

# Income over time variable
mallett <- mallett %>%
  mutate(IncomeChange2030 = (income_30-income_20)) %>%
  mutate(IncomeChange2025 = (income_25-income_20))

# Analyzing Income over Time by Age Groups:
describe(mallett$income_20)
describe(mallett$income_25)
describe(mallett$income_30)
describe(mallett$income_35)
summary(mallett$income_35) # Most are missing at 35

# Test whether income change differs among immigrants and non-immigrants
t.test(IncomeChange3020 ~ immigrant,
       data = mallett,
       var.equal=TRUE)


" Races:"
table(mallett$white)
table(mallett$black)
table(mallett$hispanic)
table(mallett$mixedrace)

# Creating a unified Race variable:
mallett <- mallett %>%
  mutate(Race = case_when(
    white == 1 ~ "White",
    black == 1 ~ "Black",
    hispanic == 1 ~ "Hispanic",
    mixedrace == 1 ~ "Mixed"
  ))

# Turn the new Race variable into a factor:
mallett$Race <- factor(mallett$Race, levels = c("White", "Black", "Hispanic", "Mixed"))
table(mallett$Race)

# Make "White" the base case:
mallett$Race <- as.factor(mallett$Race)
mallett$Race <- relevel(mallett$Race, ref = "White")

# Run a simple linear regression model by the new Race variable
Income20Race <- lm(income_20 ~ Race,
                   data = mallett)

Income25Race <- lm(income_25 ~ Race,
                   data = mallett)

Income30Race <- lm(income_30 ~ Race,
                   data = mallett)

Income35Race <- lm(income_35 ~ Race,
                   data = mallett)


# Has he/she ever been incarcerated?
mallett <- mallett %>% # Set "I" value to Missing:
  mutate(total_months_incarcerated = replace(total_months_incarcerated,
                                             total_months_incarcerated %in% c("I"), NA))

# Turn into a numeric variable:
mallett$total_months_incarcerated <- as.numeric(mallett$total_months_incarcerated)
summary(mallett$total_months_incarcerated) # Check result

# Create an incarceration indicator variable:
mallett <- mallett %>%
  mutate(Incarcerated = case_when(
    total_months_incarcerated == 0 ~ 0,
    total_months_incarcerated > 0 ~ 1,
    TRUE ~ NaN
  ))

# Check the results:
table(mallett$Incarcerated)


"Immigration Variable:"
table(mallett$immigrant)


"Number of Schools Attended:"
mallett <- mallett %>%
  mutate(NumSchoolsAttended = replace(number_schools_attended, number_schools_attended %in% c("I", "V"), NA))
table(mallett$NumSchoolsAttended)

# Convert to a numeric variable:
mallett$NumSchoolsAttended <- as.numeric(mallett$NumSchoolsAttended)


"Type of School attended in 1997:"
table(mallett$E5021709)
# Public = [1000-1099]
# Private = [2000-2099]
# Religious = [3000-3099] => Private?
# Valid Skip = -4

mallett <- mallett %>%
  mutate(SchoolType = case_when(
  E5021709 %in% seq(from=1000, to=1099, by=1) ~ "Public",
  E5021709 %in% seq(from=2000, to=2099, by=1) ~ "Private",
  E5021709 %in% seq(from=3000, to=3099, by=1) ~ "Private"))

table(mallett$SchoolType) # Check if they match up with actual frequencies


"Household Size in 1997:"
table(mallett$R1205400)
table(is.na(mallett$R1205400))

mallett <- mallett %>%
  mutate(HHSize = R1205400)

summary(mallett$HHSize)


"Urban/Rural:"
table(mallett$urban1997)

"Years of Education Completed:"
table(mallett$years_education_completed)

mallett <- mallett %>%
  mutate(years_education_completed = replace(years_education_completed, years_education_completed %in% c("I"), NA))

table(mallett$years_education_completed)

mallett$years_education_completed <- as.numeric(mallett$years_education_completed)


#### TRAUMA VARIABLES ####

"Victim of Violent Crime:"
table(mallett$S1242700)

mallett <- mallett %>%
  mutate(VictViolentCrime = replace(S1242700, S1242700 %in% c(-5, -2, -1), NA))

table(mallett$VictViolentCrime)

"Close Relative Died:"
table(mallett$S1240700)

mallett <- mallett %>%
  mutate(RelativeDied = replace(S1240700, S1240700 %in% c(-5, -2, -1), NA))

table(mallett$RelativeDied)

"Homelessness:"
table(mallett$S1242900)

mallett <- mallett %>%
  mutate(Homeless = replace(S1242900, S1242900 %in% c(-5, -2, -1), NA))

table(mallett$Homeless)

"Household Member Hospitalized:"
table(mallett$S1243100)

mallett <- mallett %>%
  mutate(HHHospital = replace(S1243100, S1243100 %in% c(-5, -2, -1), NA))

table(mallett$HHHospital)

"Household Member been in Jail:"
table(mallett$S1246500)

mallett <- mallett %>%
  mutate(HHJail = replace(S1246500, S1246500 %in% c(-5, -2, -1), NA))

table(mallett$HHJail)

"Parents have Divorced (1997-2002):"
table(mallett$divorced)
#DONE####


#### CRIME AND DELINQUENCY ####
"Ever Smoked (1997):"
table(mallett$R0357900)
mallett <- mallett %>%
  mutate(EverSmoke = replace(R0357900, R0357900 %in% c(-1, -2, -3), NA))
table(mallett$EverSmoke)

"Ever Arrested for Delinquent / Illegal Offense (1997):"
table(mallett$R0365900)
mallett <- mallett %>%
  mutate(EverArrested = replace(R0365900, R0365900 %in% c(-1, -2, -3), NA))
table(mallett$EverArrested)
#### DONE ####





"Create the Analytic Dataset:"

clean <- mallett %>%
  select(immigrant, female, black, hispanic, white, mixedrace,
         urban1997, rural1997, never_married, married, separated,
         divorced, widowed, ever_in_gang, victim_breakin_lt12yrs, victim_bully_lt12yrs,
         victim_shooting_lt12yrs, victim_breakin_12to18, victim_bully_12to18,
         victim_shooting_12to18, VictViolentCrime, ms_suspension, hs_suspension,
         hs_grad, college_degree, ged, special_education_history, bilingual_education_history,
         gifted_education_history, veteran, age, days_ms_suspension, days_hs_suspension,
         number_grades_repeated, number_grades_skipped, years_education_completed,
         highest_degree, SAT_math_score_2007, SAT_verbal_score_2007, ACT_score_2007,
         number_schools_attended, parent_expectation_in_jail_by20, age_first_incarcerated,
         income1996IA, income1997IA, income1998IA, income1999IA, income2000IA,
         income2001IA, income2002IA, income2003IA, income2004IA, income2005IA,
         income2006IA, income2007IA, income2008IA, income2009IA, income2010IA,
         income2012IA, income2014IA, income2016IA, income_20, income_25, income_30,
         income_35, assets_20, assets_25, assets_30, assets_35, debts_20, debts_25,
         debts_30, debts_35, total_n_incarcerated, total_months_incarcerated,
         months_longest_incarceration, months_first_incarceration, age_first_incarcerated,
         number_jobs_since20, Incarcerated, RelativeDied, Homeless, HHHospital, HHJail,
         NumSchoolsAttended, EverSmoke, EverArrested)

names(clean)





"Cleaning up our environment:"
rm(Income20Race)
rm(Income30Race)
rm(Income25Race)
rm(Income35Race)
rm(incomes)
rm(new_income)
















