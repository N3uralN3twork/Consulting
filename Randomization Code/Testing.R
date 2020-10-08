df <- new_data
summary(categories$CV_CITIZENSHIP_1997)
table(df$CV_CITIZENSHIP_1997)
summary(categories$CV_CITIZEN_CURRENT_2001)
table(df$CV_CITIZEN_CURRENT_2001)
summary(categories$CV_CITIZEN_CURRENT_2002)
table(df$CV_CITIZEN_CURRENT_2002)
summary(categories$CV_CITIZEN_CURRENT_2003)
table(df$CV_CITIZEN_CURRENT_2003)
summary(categories$CV_CITIZEN_CURRENT_2004)
table(df$CV_CITIZEN_CURRENT_2004)
summary(categories$CV_CITIZEN_CURRENT_2006)
table(df$CV_CITIZEN_CURRENT_2006)
summary(categories$CV_CITIZEN_CURRENT_2007)
table(df$CV_CITIZEN_CURRENT_2007)
summary(categories$CV_CITIZEN_CURRENT_2008)
table(df$CV_CITIZEN_CURRENT_2008)
summary(categories$CV_CITIZEN_CURRENT_2009)
table(df$CV_CITIZEN_CURRENT_2009)
summary(categories$CV_CITIZEN_CURRENT_2010)
table(df$CV_CITIZEN_CURRENT_2010)
summary(categories$CV_CITIZEN_CURRENT_2011)
table(df$CV_CITIZEN_CURRENT_2011)
summary(categories$CV_CITIZEN_CURRENT_2013)
table(df$CV_CITIZEN_CURRENT_2013)
summary(categories$CV_CITIZEN_CURRENT_2015)
table(df$CV_CITIZEN_CURRENT_2015)

library(dplyr)
"Are you a citizen at all throughout the years of the study?"
df <- df %>%
  mutate(Citizenship = case_when(
    CV_CITIZENSHIP_1997 == 1 |
    CV_CITIZEN_CURRENT_2001 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2002 %in% c(1, 2) | 
    CV_CITIZEN_CURRENT_2003 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2004 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2006 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2007 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2008 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2009 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2010 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2011 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2013 %in% c(1, 2) |
    CV_CITIZEN_CURRENT_2015 %in% c(1, 2) ~ 1,
    TRUE ~ 0))

table(df$Citizenship)
prop.table(table(df$Citizenship))

"Were you a citizen before you turned 18?"

"What age did you receive your US citizenship (14+)"

"Foreign-born vs. native-born?"











