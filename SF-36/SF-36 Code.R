setwd("C:/Users/MatthiasQ.MATTQ/Desktop/SF-36") # PC
setwd("C:/Users/miqui/OneDrive/Consulting/SF-36") # Desktop
getwd()
list.files()


#Read in the practice dataset
library(readxl)
data1 <- read_excel("Practice SF-36 data.xlsx", 
                    sheet = "Practice SF-36 data")
data1 <- as.data.frame(data1)
View(data1)

data = data1

#install.packages("DistributionUtils")
#install.packages("sjmisc")
library(DistributionUtils)
library(sjmisc)

## Data Cleanser ##
### change n/a to 0
### Change decimals to 0
### Change negative numbers to 0
row_count = nrow(data)
col_count = ncol(data)


for(i in 1:row_count)
{
  for(j in 2:col_count)
  {
    if(is.na(data[i,j]))
    {
      data[i,j] = NA
      next(j)
      #code it as negative one to all the program to continue to run
    }
    if(data[i,j] < 0)
    {
      data[i,j] = NA
      next(j)
    }
    if(is.wholenumber(data[i,j]))
    {
      data[i,j] = data[i,j]
    }
    else
    {
      data[i,j] = NA
    }
  }
}



##Check columns to identify if there are out of range
Clean_data = data
cols = c(4:13)

for(i in 1:row_count)
{
  for(j in cols)
  {
    if(is.na(Clean_data[i,j]))
    {
      Clean_data[i,j] = NA
      next(j)
      #code it as negative one to all the program to continue to run
    }
    
    if(Clean_data[i,j] > 3)
    {
      Clean_data[i,j] = NA
    }
  }
}


cols = c(2:3,c(14:21),c(23:37));cols

for(i in 1:row_count)
{
  for(j in cols)
  {
    if(is.na(Clean_data[i,j]))
    {
      Clean_data[i,j] = NA
      next(j)
      #code it as negative one to all the program to continue to run
    }
    if(Clean_data[i,j] > 5)
    {
      Clean_data[i,j] = NA
    }
  }
}


cols = 22;cols

for(i in 1:row_count)
{
  for(j in cols)
  {
    if(is.na(Clean_data[i,j]))
    {
      Clean_data[i,j] = NA
      next(j)
      #code it as negative one to all the program to continue to run
    }
    if(Clean_data[i,j] > 6)
    {
      Clean_data[i,j] = NA
    }
  }
}

Clean_data[36,c(22,23,40)]
#############################
######## Raw PF #############
#############################
PF_Clean_data = Clean_data
cols = c(4:13)
for(i in 1:row_count)
{
  counter = 0
  for(j in cols)
  {
    if(!is.na(Clean_data[i,j]))
    {
      counter = counter + 1 
    }
  }
  PF_Mean = sum(Clean_data[i,c(4:13)],na.rm = TRUE)/counter
  for(j in cols)
  {
    if(counter >= 5 && is.na(PF_Clean_data[i,j]))
    {
      PF_Clean_data[i,j] = PF_Mean
    }
  }
  PF_Clean_data[i,38] = sum(PF_Clean_data[i,c(4:13)])
}

PF_Clean_data[,38]


#############################
######## Raw RP #############
#############################
RP_Clean_data = PF_Clean_data 
cols = c(14:17)
for(i in 1:row_count)
{
  counter = 0
  for(j in cols)
  {
    if(!is.na(Clean_data[i,j]))
    {
      counter = counter + 1 
    }
  }
  RP_Mean = sum(Clean_data[i,c(14:17)],na.rm = TRUE)/counter
  for(j in cols)
  {
    if(counter >= 2 && is.na(RP_Clean_data[i,j]))
    {
      RP_Clean_data[i,j] = RP_Mean
    }
  }
  RP_Clean_data[i,39] = sum(RP_Clean_data[i,c(14:17)])
}

#############################
######## Raw BP #############
#############################
BP_Clean_data = RP_Clean_data 
cols = c(22:23)
for(i in 1:row_count)
{    
  if((is.na(Clean_data[i,22])) && (is.na(Clean_data[i,23])))
  {
    BP_Clean_data[i,22] = NA
    BP_Clean_data[i,23] = NA
    BP_Clean_data[i,40] = NA
    next(i)
  }
  if((is.na(Clean_data[i,22])) && (!is.na(Clean_data[i,23])))
  {
    if(Clean_data[i,23] == 1)
    {item8= 6}
    if(Clean_data[i,23] == 2)
    {item8= 4.75}
    if(Clean_data[i,23] == 3)
    {item8= 3.5}
    if(Clean_data[i,23] == 4)
    {item8= 2.25}
    if(Clean_data[i,23] == 5)
    {item8= 1}
    BP_Clean_data[i,22] = item8
    BP_Clean_data[i,23] = item8
  }
  if(!is.na(Clean_data[i,22]))
  {
    if(Clean_data[i,22] == 1)
    {item7= 6}
    if(Clean_data[i,22] == 2)
    {item7= 5.4}
    if(Clean_data[i,22] == 3)
    {item7= 4.2}
    if(Clean_data[i,22] == 4)
    {item7= 3.1}
    if(Clean_data[i,22] == 5)
    {item7= 2.2}
    if(Clean_data[i,22] == 6)
    {item7= 1}
    BP_Clean_data[i,22] = item7
  }
  if(is.na(Clean_data[i,23]) && !is.na(Clean_data[i,22]))
  {
    item8 = item7
    BP_Clean_data[i,23] = item8
    BP_Clean_data[i,40] = BP_Clean_data[i,22] + BP_Clean_data[i,23]
    next(i)
  }
  if((!is.na(Clean_data[i,22])) && (!is.na(Clean_data[i,23])))
  {
    if( (Clean_data[i,23] == 1) && (Clean_data[i,22] == 1))
    {item8= 6}
    if((Clean_data[i,23] == 1) && (Clean_data[i,22] > 1))
    {item8= 5}
    if(Clean_data[i,23] == 2)
    {item8= 4}
    if(Clean_data[i,23] == 3)
    {item8= 3}
    if(Clean_data[i,23] == 4)
    {item8= 2}
    if(Clean_data[i,23] == 5)
    {item8= 1}
    BP_Clean_data[i,23] = item8
  }
  BP_Clean_data[i,40] = BP_Clean_data[i,22] + BP_Clean_data[i,23]
}

BP_Clean_data[36,c(22,23,40)]


#############################
######## Raw GH #############
#############################
GH_Clean_data = BP_Clean_data
cols = c(2,c(34:37))

for(i in 1:row_count)
{    
  {
    GH_Clean_data$count[i] = sum(apply(Clean_data[i,cols],2, FUN = function(x) sum(!is.na(x))))
  }
  if(GH_Clean_data$count[i] <= 2)
  {
    GH_Clean_data[i,41] = NA
    next(i)
  }
  if(GH_Clean_data$count[i] > 2)
  {
    if(!is.na(Clean_data[i,2]))
    {
      ##Scoring for Q1
      if(is.na(Clean_data[i,2]))
      {GH_Clean_data[i,2] = NA}
      if(Clean_data[i,2]==1)
      {GH_Clean_data[i,2] = 5}
      if(Clean_data[i,2]==2)
      {GH_Clean_data[i,2] = 4.4}
      if(Clean_data[i,2]==3)
      {GH_Clean_data[i,2] = 3.4}
      if(Clean_data[i,2]==4)
      {GH_Clean_data[i,2] = 2}
      if(Clean_data[i,2]==5)
      {GH_Clean_data[i,2] = 1}
    }
    
    #Scoring for Q11.A
    if(is.na(Clean_data[i,34]))
    {GH_Clean_data[i,34] = NA}else
    {GH_Clean_data[i,34] = GH_Clean_data[i,34]}
    
    #Scoring for Q11.D
    if(is.na(Clean_data[i,36]))
    {GH_Clean_data[i,36] = NA}else
    {GH_Clean_data[i,36] = GH_Clean_data[i,36]}
    
    #Scoring for Q11.B
    if(is.na(Clean_data[i,35]))
    {GH_Clean_data[i,35] = NA}else
    {GH_Clean_data[i,35] = abs(GH_Clean_data[i,35]-5)+1}
    
    #Scoring for Q11.C
    if(is.na(Clean_data[i,37]))
    {GH_Clean_data[i,37]=NA}else
    {GH_Clean_data[i,37] = abs(GH_Clean_data[i,37]-5)+1}
    
    #Duplicate the adjusted DF
    GH2 = GH_Clean_data[,cols]
    
    #Dealing with missing values
    cols2 = c(2:5)
    cols3 = c(1,3:5)
    cols4 = c(1:2,4:5)
    cols5 = c(1:3,5)
    cols6 = c(1:4)
    
    if(is.na(Clean_data[i,2]))
    {
      GH_Clean_data[i,2]= rowMeans(GH2[i,cols2],na.rm = T)
    }
    if(is.na(Clean_data[i,34]))
    {
      GH_Clean_data[i,34]= rowMeans(GH2[i,cols3],na.rm = T)
    }
    if(is.na(Clean_data[i,35]))
    {
      GH_Clean_data[i,35]= rowMeans(GH2[i,cols4],na.rm = T)
    }
    if(is.na(Clean_data[i,36]))
    {
      GH_Clean_data[i,36]= rowMeans(GH2[i,cols5],na.rm = T)
    }
    if(is.na(Clean_data[i,37]))
    {
      GH_Clean_data[i,37]= rowMeans(GH2[i,cols6],na.rm = T)
    }
    
    GH_Clean_data[i,41] = sum(GH_Clean_data[i,cols])  
    #Closes if counter > 2  
  }
  
}


GH_Clean_data[,c(cols,41,70)]





#############################
######## Raw VT #############
#############################
VT_Clean_data = GH_Clean_data[1:69]

cols = c(24,28,30,32)

for(i in 1:row_count)
{    
  {
    VT_Clean_data$count[i] = sum(apply(Clean_data[i,cols],2,FUN = function(x) sum(!is.na(x))))
  }
  if(VT_Clean_data$count[i] < 2)
  {
    VT_Clean_data[i,42] = NA
    next(i)
  }
  if(VT_Clean_data$count[i] >= 2)
  {
    #Scoring for Q9.g
    if(is.na(Clean_data[i,30]))
    {VT_Clean_data[i,30] = NA}else
    {VT_Clean_data[i,30] = VT_Clean_data[i,30]}
    
    #Scoring for Q9.i
    if(is.na(Clean_data[i,32]))
    {VT_Clean_data[i,32] = NA}else
    {VT_Clean_data[i,32] = VT_Clean_data[i,32]}
    
    #Scoring for Q9.a
    if(is.na(Clean_data[i,24]))
    {VT_Clean_data[i,24] = NA}else
    {VT_Clean_data[i,24] = abs(VT_Clean_data[i,24]-5)+1}
    
    #Scoring for Q9.e
    if(is.na(Clean_data[i,28]))
    {VT_Clean_data[i,28]=NA}else
    {VT_Clean_data[i,28] = abs(VT_Clean_data[i,28]-5)+1}
    
    #Duplicate the adjusted DF
    VT2 = VT_Clean_data[,cols]
    
    #Dealing with missing values
    cols2 = c(2:4)
    cols3 = c(1,3:4)
    cols4 = c(1:2,4)
    cols5 = c(1:3)
    
    if(is.na(Clean_data[i,24]))
    {
      VT_Clean_data[i,24]= rowMeans(VT2[i,cols2], na.rm = T)
    }
    if(is.na(Clean_data[i,28]))
    {
      VT_Clean_data[i,28]= rowMeans(VT2[i,cols3],na.rm = T)
    }
    if(is.na(Clean_data[i,30]))
    {
      VT_Clean_data[i,30]= rowMeans(VT2[i,cols4],na.rm = T)
    }
    if(is.na(Clean_data[i,32]))
    {
      VT_Clean_data[i,32]= rowMeans(VT2[i,cols5],na.rm = T)
    }
    
    VT_Clean_data[i,42] = sum(VT_Clean_data[i,cols])  
    #Closes if counter > 2  
  }
  
}


VT_Clean_data[,c(cols,42,70)]


#############################
######## Raw SF #############
#############################
SF_Clean_Data = VT_Clean_data[1:69]
head(SF_Clean_Data)
cols = c(21,33)

for(i in 1:row_count)
{    
  {
    SF_Clean_Data$count[i] = sum(apply(Clean_data[i,cols],2, FUN = function(x) sum(!is.na(x))))
  }
  if(SF_Clean_Data$count[i] < 1)
  {
    SF_Clean_Data[i,43] = NA
    next(i)
  }
  if(SF_Clean_Data$count[i] >= 1)
  {
    #Scoring for Q6
    if(is.na(Clean_data[i,21]))
    {SF_Clean_Data[i,21] = NA}else
    {SF_Clean_Data[i,21] = abs(SF_Clean_Data[i,21]-5)+1}
    
    #Scoring for Q10
    if(is.na(Clean_data[i,33]))
    {SF_Clean_Data[i,33] = NA}else
    {SF_Clean_Data[i,33] = SF_Clean_Data[i,33]}
    
    #Duplicate the adjusted DFs
    SF2 = SF_Clean_Data[,cols]
    
    #Dealing with missing values
    cols2 = c(2)
    cols3 = c(1)
    if(is.na(Clean_data[i,21]))
    {
      SF_Clean_Data[i,21]= SF2[i,2]
    }
    if(is.na(Clean_data[i,33]))
    {
      SF_Clean_Data[i,33]= SF2[i,1]
    }
    
    SF_Clean_Data[i,43] = sum(SF_Clean_Data[i,cols])  
    #Closes if counter > 2  
  }
  
}


SF_Clean_Data[,c(cols,43,70)]

#############################
######## Raw RE #############
#############################
RE_Clean_data = SF_Clean_Data[1:69]
cols = c(18:20)

for(i in 1:row_count)
{    
  {
    RE_Clean_data$count[i] = sum(apply(Clean_data[i,cols],2,FUN = function(x) sum(!is.na(x))))
  }
  if(RE_Clean_data$count[i] < 2)
  {
    RE_Clean_data[i,44] = NA
    next(i)
  }
  if(RE_Clean_data$count[i] >= 2)
  {
    
    #Scoring for Q5.A
    if(is.na(Clean_data[i,18]))
    {RE_Clean_data[i,18] = NA}else
    {RE_Clean_data[i,18] = RE_Clean_data[i,18]}
    
    #Scoring for Q5.B
    if(is.na(Clean_data[i,19]))
    {RE_Clean_data[i,19] = NA}else
    {RE_Clean_data[i,19] = RE_Clean_data[i,19]}
    
    #Scoring for Q5.C
    if(is.na(Clean_data[i,20]))
    {RE_Clean_data[i,20] = NA}else
    {RE_Clean_data[i,20] = RE_Clean_data[i,20]}
    
    
    #Duplicate the adjusted DF
    RE2 = RE_Clean_data[,cols]
    
    #Dealing with missing values
    cols2 = c(2,3)
    cols3 = c(1,3)
    cols4 = c(1,2)
    
    if(is.na(Clean_data[i,18]))
    {
      RE_Clean_data[i,18]= rowMeans(RE2[i,cols2],na.rm = T)
    }
    if(is.na(Clean_data[i,19]))
    {
      RE_Clean_data[i,19]= rowMeans(RE2[i,cols3],na.rm = T)
    }
    if(is.na(Clean_data[i,20]))
    {
      RE_Clean_data[i,20]= rowMeans(RE2[i,cols4],na.rm = T)
    }
    
    RE_Clean_data[i,44] = sum(RE_Clean_data[i,cols])  
    #Closes if counter > 2  
  }
  
}


RE_Clean_data[,c(cols,44,70)]


#############################
######## Raw MH #############
#############################
MH_Clean_data = RE_Clean_data[1:69]

cols = c(25:27,29,31)

for(i in 1:row_count)
{    
  {
    MH_Clean_data$count[i] = sum(apply(Clean_data[i,cols],2,FUN = function(x) sum(!is.na(x))))
  }
  if(MH_Clean_data$count[i] < 3)
  {
    MH_Clean_data[i,45] = NA
    next(i)
  }
  if(MH_Clean_data$count[i] >= 3)
  {
    #Scoring for Q9.B
    if(is.na(Clean_data[i,25]))
    {MH_Clean_data[i,25] = NA}else
    {MH_Clean_data[i,25] = MH_Clean_data[i,25]}
    
    #Scoring for Q9.C
    if(is.na(Clean_data[i,26]))
    {MH_Clean_data[i,26] = NA}else
    {MH_Clean_data[i,26] = MH_Clean_data[i,26]}
    
    #Scoring for Q9.F
    if(is.na(Clean_data[i,29]))
    {MH_Clean_data[i,29] = NA}else
    {MH_Clean_data[i,29] = MH_Clean_data[i,29]}
    
    #Scoring for Q9.D
    if(is.na(Clean_data[i,27]))
    {MH_Clean_data[i,27] = NA}else
    {MH_Clean_data[i,27] = abs(MH_Clean_data[i,27]-5)+1}
    
    #Scoring for Q9.H
    if(is.na(Clean_data[i,31]))
    {MH_Clean_data[i,31]=NA}else
    {MH_Clean_data[i,31] = abs(MH_Clean_data[i,31]-5)+1}
    
    #Duplicate the adjusted DF
    MH2 = MH_Clean_data[,cols]
    
    #Dealing with missing values
    cols2 = c(2:5)
    cols3 = c(1,3:5)
    cols4 = c(1:2,4:5)
    cols5 = c(1:3,5)
    cols6 = c(1:4)
    
    if(is.na(Clean_data[i,25]))
    {
      MH_Clean_data[i,25]= rowMeans(MH2[i,cols2],na.rm = T)
    }
    if(is.na(Clean_data[i,26]))
    {
      MH_Clean_data[i,26]= rowMeans(MH2[i,cols3],na.rm = T)
    }
    if(is.na(Clean_data[i,27]))
    {
      MH_Clean_data[i,27]= rowMeans(MH2[i,cols4],na.rm = T)
    }
    if(is.na(Clean_data[i,29]))
    {
      MH_Clean_data[i,29]= rowMeans(MH2[i,cols5],na.rm = T)
    }
    if(is.na(Clean_data[i,31]))
    {
      MH_Clean_data[i,31]= rowMeans(MH2[i,cols6],na.rm = T)
    }
    
    MH_Clean_data[i,45] = sum(MH_Clean_data[i,cols])  
    #Closes if counter > 2  
  }
  
}


MH_Clean_data[,c(cols,45,70)]




#############################
######## Raw HT #############
#############################
#HT_Clean_data = MH_Clean_data[1:45]

#cols = 3

#for(i in 1:row_count)
#{    
#  HT_Clean_data[i,46] = HT_Clean_data[i,3]
#}
#
#HT_Clean_data[,c(3,46)]



##################################
##################################
######## TRANSFORMATIONS #########
##################################
##################################

Trans_Data = MH_Clean_data[1:69]
for(i in 1:row_count)
{
  #Transformed PF
  if(is.na(Trans_Data[i,38]))
  {
    Trans_Data[i,46] = NA
  }else
  {
    Trans_Data[i,46] = (Trans_Data[i,38]-10)/20*100
  }
  
  #Transformed RP
  if(is.na(Trans_Data[i,39]))
  {
    Trans_Data[i,47] = NA
  }else
  {
    Trans_Data[i,47] = (Trans_Data[i,39]-4)/16*100
  }
  
  #Transformed BP
  if(is.na(Trans_Data[i,40]))
  {
    Trans_Data[i,48] = NA
  }else
  {
    Trans_Data[i,48] = (Trans_Data[i,40]-2)/10*100
  }
  
  #Transformed GH
  if(is.na(Trans_Data[i,41]))
  {
    Trans_Data[i,49] = NA
  }else
  {
    Trans_Data[i,49] = (Trans_Data[i,41]-5)/20*100
  }
  
  #Transformed VT
  if(is.na(Trans_Data[i,42]))
  {
    Trans_Data[i,50] = NA
  }else
  {
    Trans_Data[i,50] = (Trans_Data[i,42]-4)/16*100
  }
  
  #Transformed SF
  if(is.na(Trans_Data[i,43]))
  {
    Trans_Data[i,51] = NA
  }else
  {
    Trans_Data[i,51] = (Trans_Data[i,43]-2)/8*100
  }
  
  #Transformed RE
  if(is.na(Trans_Data[i,44]))
  {
    Trans_Data[i,52] = NA
  }else
  {
    Trans_Data[i,52] = (Trans_Data[i,44]-3)/12*100
  }
  
  #Transformed MH
  if(is.na(Trans_Data[i,45]))
  {
    Trans_Data[i,53] = NA
  }else
  {
    Trans_Data[i,53] = (Trans_Data[i,45]-5)/20*100
  }
  
}

Trans_Data[,46:53]




##################################
##################################
##### Z Score Calculations #######
##################################
##################################

#The following numbers come from page 51 of the SF-36 manual
#Step 1.

Z_Data = Trans_Data[1:69]
for(i in 1:row_count)
{
  #Stand PF
  if(is.na(Z_Data[i,46]))
  {
    Z_Data[i,54] = NA
  }else
  {
    Z_Data[i,54] = ((Z_Data[i,46]-83.29094)/23.75883)
  }
  
  #Stand RP
  if(is.na(Z_Data[i,47]))
  {
    Z_Data[i,55] = NA
  }else
  {
    Z_Data[i,55] = ((Z_Data[i,47]-82.50964)/25.52028)
  }
  
  #Stand BP
  if(is.na(Z_Data[i,48]))
  {
    Z_Data[i,56] = NA
  }else
  {
    Z_Data[i,56] =((Z_Data[i,48]-71.32527)/23.66224)
  }
  
  #Stand GH
  if(is.na(Z_Data[i,49]))
  {
    Z_Data[i,57] = NA
  }else
  {
    Z_Data[i,57] = ((Z_Data[i,49]-70.84570)/20.97821)
  }
  
  #Stand VT
  if(is.na(Z_Data[i,50]))
  {
    Z_Data[i,58] = NA
  }else
  {
    Z_Data[i,58] = ((Z_Data[i,50]-58.31411)/20.01923)
  }
  
  #Stand SF
  if(is.na(Z_Data[i,51]))
  {
    Z_Data[i,59] = NA
  }else
  {
    Z_Data[i,59] = ((Z_Data[i,51]-84.30250)/22.91921)
  }
  
  #Stand RE
  if(is.na(Z_Data[i,52]))
  {
    Z_Data[i,60] = NA
  }else
  {
    Z_Data[i,60] = ((Z_Data[i,52]-87.39733)/21.43778)
  }
  
  #Stand MH
  if(is.na(Z_Data[i,53]))
  {
    Z_Data[i,61] = NA
  }else
  {
    Z_Data[i,61] = ((Z_Data[i,53]-74.98685)/17.75604)
  }
}

Z_Data[,54:61]

##################################
##################################
######## Standardization #########
##################################
##################################

Stand_Data = Z_Data[1:69]
for(i in 1:row_count)
{
  #Stand PF
  if(is.na(Stand_Data[i,54]))
  {
    Stand_Data[i,62] = NA
  }else
  {
    Stand_Data[i,62] = 50 + Stand_Data[i,54]*10
  }
  
  #Stand RP
  if(is.na(Stand_Data[i,55]))
  {
    Stand_Data[i,63] = NA
  }else
  {
    Stand_Data[i,63] = 50 + Stand_Data[i,55]*10
  }
  
  #Stand BP
  if(is.na(Stand_Data[i,56]))
  {
    Stand_Data[i,64] = NA
  }else
  {
    Stand_Data[i,64] = 50 + Stand_Data[i,56]*10
  }
  
  #Stand GH
  if(is.na(Stand_Data[i,57]))
  {
    Stand_Data[i,65] = NA
  }else
  {
    Stand_Data[i,65] = 50 + Stand_Data[i,57]*10
  }
  
  #Stand VT
  if(is.na(Stand_Data[i,58]))
  {
    Stand_Data[i,66] = NA
  }else
  {
    Stand_Data[i,66] = 50 + Stand_Data[i,58]*10
  }
  
  #Stand SF
  if(is.na(Stand_Data[i,59]))
  {
    Stand_Data[i,67] = NA
  }else
  {
    Stand_Data[i,67] = 50 + Stand_Data[i,59]*10
  }
  
  #Stand RE
  if(is.na(Stand_Data[i,60]))
  {
    Stand_Data[i,68] = NA
  }else
  {
    Stand_Data[i,68] = 50 + Stand_Data[i,60]*10
  }
  
  #Stand MH
  if(is.na(Stand_Data[i,61]))
  {
    Stand_Data[i,69] = NA
  }else
  {
    Stand_Data[i,69] = 50 + Stand_Data[i,61]*10
  }
}

Stand_Data[,62:69]

########################################
########################################
######### Aggregate Columns ############
########################################
########################################
Agg_Data = Stand_Data

for(i in 1:row_count)
{
  for( j in 54:61)
  {
    if(is.na(Agg_Data[i,j]))
    {
      Agg_Data$AGG_PHYS[i] = NA
      Agg_Data$AGG_MENT[i] = NA
      Agg_Data$PCS[i] = NA
      Agg_Data$MCS[i] = NA
      next(i)
    }
  }
  
  Agg_Data$AGG_PHYS[i] =
    (Agg_Data$Standardized_PF[i]*0.42402) + (Agg_Data$Standardized_RP[i]*0.35119)+
    (Agg_Data$Standardized_BP[i]*0.31754) + (Agg_Data$Standardized_GH[i]*0.24954)+
    (Agg_Data$Standardized_VT[i]*0.02877) + (Agg_Data$Standardized_SF[i]*-0.00753)+
    (Agg_Data$Standardized_RE[i]*-0.19206) + (Agg_Data$Standardized_MH[i]*-0.22069)
  
  Agg_Data$AGG_MENT[i] = 
    (Agg_Data$Standardized_PF[i]*-0.22999) + (Agg_Data$Standardized_RP[i]*-0.12329)+
    (Agg_Data$Standardized_BP[i]*-0.09731) + (Agg_Data$Standardized_GH[i]*-0.01571)+
    (Agg_Data$Standardized_VT[i]*0.23534) + (Agg_Data$Standardized_SF[i]*0.26876)+
    (Agg_Data$Standardized_RE[i]*0.43407) + (Agg_Data$Standardized_MH[i]*0.48581)
  
  Agg_Data$PCS[i] = 50 + Agg_Data$AGG_PHYS[i]*10
  Agg_Data$MCS[i] = 50 + Agg_Data$AGG_MENT[i]*10
  
}

##### Final Data Set ######

Final_data = as.data.frame(data1[,1:37])

Final_data = cbind(Final_data, round(Stand_Data[,38:69], digits= 2))


#Round to 2 decimal
head(Final_data)


#Remove NA's
Final_data[is.na(Final_data)] <- ""

Final_data

write.csv(Final_data,"SF_Scored_Data.csv", row.names = FALSE)
getwd()
