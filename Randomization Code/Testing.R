
"Whole dataset: "
sf12 <- read_csv("SF-12.csv")
View(sf12)
attach(sf12)


"Individual variable frequencies: "
# In general, would you say your health is... :
table(H0015900)

# Health limits in moderate activities ... :
table(H0016000)

# Health limits climbing several flights of stairs ... :
table(H0016100)

# Accomplished less than you would like / physical health ... :
table(H0016200)

# Limited in the kind of work or daily activities ... :
table(H0016300)

# Accomplished less than you would like / emotional health ... :
table(H0016400)

# Did work less carefully / emotional health ... :
table(H0016500)

# How much did pain interfere with your normal work :
table(H0016600)

# How much of the time have you felt calm and peaceful : 
table(H0016700)

# How much of the time did you have a lot of energy :
table(H0016800)

# How much of the time did you feel downhearted and blue :
table(H0016900)

# Health interfered with your social activities :
table(H0017000)


"The codebook provided for dataset 3 matches up with data3!"

"""
-1 = Refusal
-2 = Don't Know
-4 = Legitamite Skip
-5 = Non-interview
"""

sf12 <- sf12 %>%
  mutate(GeneralHealth = replace(H0015900, H0015900 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(ModerateActivities = replace(H0016000, H0016000 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(Stairs = replace(H0016100, H0016100 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(AccomplishLessPhysical = replace(H0016200, H0016200 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(LimitedWork = replace(H0016300, H0016300 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(AccomplishLessEmotional = replace(H0016400, H0016400 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(WorkLessCareful = replace(H0016500, H0016500 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(PainInterfere = replace(H0016600, H0016600 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(CalmPeaceful = replace(H0016700, H0016700 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(LotsEnergy = replace(H0016800, H0016800 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(FeelBlue = replace(H0016900, H0016900 %in% c(-1, -2, -4, -5), NA)) %>%
  mutate(SocialActivities = replace(H0017000, H0017000 %in% c(-1, -2, -4, -5), NA))

attach(sf12)
table(GeneralHealth)
table(ModerateActivities)
table(Stairs)
table(AccomplishLessPhysical)
table(LimitedWork)
table(AccomplishLessEmotional)
table(WorkLessCareful)
table(PainInterfere)
table(CalmPeaceful)
table(LotsEnergy)
table(FeelBlue)
table(SocialActivities)
