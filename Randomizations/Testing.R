code <- "AAA100C"

FINAL["Site"] <-  substr(FINAL$V1, 1, 3)
FINAL["Subject"] <-  gsub("[a-zA-Z]+", "", FINAL$V1) # remove letters with regex
FINAL["Group"] <- substr(FINAL$V1, nchar(FINAL$V1), nchar(FINAL$V1))


