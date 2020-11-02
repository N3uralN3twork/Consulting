table(clean$highest_degree)
table(clean$years_education_completed)

linear <- lm(years_education_completed ~ days_ms_suspension + hs_grad,
             data = clean)
summary(linear)



summary(clean$years_education_completed)
table(clean$years_education_completed)


t.test(years_education_completed ~ hs_grad,
       data = clean)

table(clean$hs_grad)
