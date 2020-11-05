model <- glm(hs_grad ~ immigrant + days_ms_suspension + black + NumSchoolsAttended + female,
             data = clean,
             family=binomial(link="logit"))
summary(model)
exp(coef(model))
