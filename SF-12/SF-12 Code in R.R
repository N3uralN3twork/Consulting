setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/SF-12")
library(MLCIRTwithin)
library(readr)
library(readxl)
library(dplyr)
library(psych)

"No missing dataset: "
nomiss <- read_excel("SF12_nomissing.xlsx")
View(nomiss)

"Add 1 to all columns except age:"

PlusOne <- c('Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6', 'Y7', 'Y8', 'Y9', 'Y10', 'Y11', 'Y12')

nomiss[PlusOne] = nomiss[PlusOne] + 1
summary(nomiss)

"Code Out-of-Range Values to NA"
# Must be an easier way to do this like in Python
nomiss <- nomiss %>%
  mutate(Y1 = case_when(
    between(Y1, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y2 = case_when(
    between(Y2, 1, 4) = FALSE ~ NaN)) %>%
  mutate(Y3 = case_when(
    between(Y3, 1, 4) = FALSE ~ NaN)) %>%
  mutate(Y4 = case_when(
    between(Y4, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y5 = case_when(
    between(Y5, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y6 = case_when(
    between(Y6, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y7 = case_when(
    between(Y7, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y8 = case_when(
    between(Y8, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y9 = case_when(
    between(Y9, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y10 = case_when(
    between(Y10, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y11 = case_when(
    between(Y11, 1, 5) = FALSE ~ NaN)) %>%
  mutate(Y12 = case_when(
    between(Y12, 1, 5) = FALSE ~ NaN))
summary(nomiss)

"Reverse Scoring 4 Items to a Higher Scale: "
ReverseVars = c("Y8", "Y9", "Y10")

table(nomiss$Y8)
nomiss[ReverseVars] = 6-nomiss[ReverseVars]
table(nomiss$Y8)

"Recalibrating Item 1: "

table(nomiss$Y1)

nomiss <- nomiss %>%
  mutate(Y1 = case_when(
    is.na(Y1) ~ NaN,
    Y1 == 1 ~ 5,
    Y1 == 2 ~ 4.4,
    Y1 == 3 ~ 3.4,
    Y1 == 4 ~ 2,
    Y1 == 5 ~ 1))

table(nomiss$Y1)

"Check that the results make sense using a cross-tab table: "

table(nomiss$Y1, nomiss$Y)

"Create the 8 Scales: "
Items = nomiss

Items["PF"] <- nomiss["Y2"] + nomiss["Y3"]
Items["RP"] <- nomiss["Y4"] + nomiss["Y5"]
Items["BP"] <- nomiss["Y8"]
Items["GH"] <- nomiss["Y1"]
Items["VT"] <- nomiss["Y10"]
Items["SF"] <- nomiss["Y12"]
Items["RE"] <- nomiss["Y6"] + nomiss["Y7"]
Items["MH"] <- nomiss["Y9"] + nomiss["Y11"]


"Standardize to 100 point scales: "
Items["TransPF"] <- ((Items["PF"]-2)/4)*100
Items["TransRP"] <- ((Items["RP"]-2)/8)*100
Items["TransBP"] <- ((Items["BP"]-1)/4)*100
Items["TransGH"] <- ((Items["GH"]-1)/4)*100
Items["TransVT"] <- ((Items["VT"]-1)/4)*100
Items["TransSF"] <- ((Items["SF"]-1)/4)*100
Items["TransRE"] <- ((Items["RE"]-2)/8)*100
Items["TransMH"] <- ((Items["MH"]-2)/8)*100

"Transform to Z-Scores: "

Items["PF_Z"] <- (Items["TransPF"] - 81.18122)/29.10558
Items["RP_Z"] <- (Items["TransRP"] - 80.52856)/27.13526
Items["BP_Z"] <- (Items["TransBP"] - 81.74015)/24.53019
Items["GH_Z"] <- (Items["TransGH"] - 72.19795)/23.19041
Items["VT_Z"] <- (Items["TransVT"] - 55.59090)/24.84380
Items["SF_Z"] <- (Items["TransSF"] - 83.73973)/24.75775
Items["RE_Z"] <- (Items["TransRE"] - 86.41051)/22.35543
Items["MH_Z"] <- (Items["TransMH"] - 70.18217)/20.50597

describe(Items)

"Create Aggregate Scale Scores using Factor Weights: "

Items["AGG_PHYS"] = (Items["PF_Z"]*0.42402) + (Items["RP_Z"]*0.35119) + (Items["BP_Z"]*0.31754) + (Items["GH_Z"]*0.24954) +
                    (Items["VT_Z"]*0.02877) + (Items["SF_Z"]*-0.00753) + (Items["RE_Z"]*-0.19206) + (Items["MH_Z"]*-0.22069)

Items["AGG_MENT"] = (Items["PF_Z"]*-0.22999) + (Items["RP_Z"]*-0.12329) + (Items["BP_Z"]*-0.09731) + (Items["GH_Z"]*-0.01571) +
                    (Items["VT_Z"]*0.23534) + (Items["SF_Z"]*0.26876) + (Items["RE_Z"]*0.43407) + (Items["MH_Z"]*0.48581)


"Aggregate T-Scores: "
Items["TransPHYS"] = 50 + (Items["AGG_PHYS"]*10)
Items["TransMENT"] = 50 + (Items["AGG_MENT"]*10)

describe(Items)
