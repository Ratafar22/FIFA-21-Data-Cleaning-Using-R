#load the libraries
library(tidyverse)
library("scales")
#load the data
new_data <- read.csv("C:/Users/Raufr/OneDrive/Desktop/R/Data Cleaning with R/fifa21 raw data v2.csv")
view(new_data)

# Removing white spaces from club column
new_data$Club<- gsub("\\s+", "", new_data$Club)

#Create a Contract_type to indicate if players are on contract, on loan or free
new_data <- new_data %>%
  mutate(Contract_type = case_when(
    grepl("~",Contract) ~ "Contract",
    grepl("L", Contract) ~ "On Loan",
    grepl("F",Contract) ~ "Free") )
unique(new_data$Contract_type)

#split contract column into Contract_Start and Contract_End Columns 
new_data <- separate(new_data,Contract, into = c('Contract_Start','Contract_End'),sep = "~")


#cleaning Height column
v <<- 1
for (val in new_data$Height) {
  if (grepl("cm",val)) {
    val <- gsub("cm","", val)
    new_data$Height[v] = val
  }
  else if (grepl("'",val)){
    val <- gsub("'","", val)
    val <- gsub('"',"",val)
    
    if (as.numeric(val) < 100){
      wholenumber <- floor(as.numeric(val)/10)
      decimal <- as.numeric(val) - floor(as.numeric(val)/10) * 10
      val <- wholenumber * 30.48 + (decimal) * 2.54
    }
    else
    { 
      wholenumber <- floor(as.numeric(val)/100)
      decimal <- as.numeric(val) - floor(as.numeric(val)/100) * 100
      val <- wholenumber * 30.48 + (decimal) * 2.54
    }
    new_data$Height[v] = val
  }
  else{}
  v <- v+1
}
new_data$Height <- as.numeric(new_data$Height)  #convert height to number
print(new_data$Height)

#cleaning Weight column
v <<- 1
for (val in new_data$Weight) {
  
  if (grepl("kg",val)){
    val <- gsub("kg","", val)
    new_data$Weight[v] = val
  }
  else if (grepl("lbs",val)){
    val <- gsub("lbs","", val)
    new_data$Weight[v] = as.numeric(val) * 0.454
  }
  else{}
  v <- v+1
}
new_data$Weight <- as.numeric(new_data$Weight)  #convert weight column to numeric

#clean the Value Column
new_data$Value <- gsub("€","", new_data$Value)
v <<- 1
for (val in new_data$Value) {
  
  if (grepl("M",val)){
    val <- gsub("M","", val)
    new_data$Value[v] = as.numeric(val) * 1000000
  }
  else if (grepl("K",val)){
    val <- gsub("K","", val)
    new_data$Value[v] = as.numeric(val) * 1000
  }
  else{}
  v <- v+1
}
# convert from euros to dollars
new_data$Value <-as.numeric(new_data$Value)
new_data$Value <- new_data$Value * 1.06       #official rate as at March 16 2023

#cleaning Wage Column
new_data$Wage <- gsub("€","", new_data$Wage)
v <<- 1
for (val in new_data$Wage) {
  
  if (grepl("M",val)){
    val <- gsub("M","", val)
    new_data$Wage[v] = as.numeric(val) * 1000000
  }
  else if (grepl("K",val)){
    val <- gsub("K","", val)
    new_data$Wage[v] = as.numeric(val) * 1000
  }
  else{}
  v <- v+1
}
# convert from euros to dollars
new_data$Wage <- as.numeric(new_data$Wage)
new_data$Wage <- new_data$Wage * 1.06

#Cleaning Released.Clause column
new_data$Release.Clause <- gsub("€","", new_data$Release.Clause)
v <<- 1
for (val in new_data$Release.Clause) {
  if (grepl("M",val)){
    val <- gsub("M","", val)
    new_data$Release.Clause[v] = as.numeric(val) * 1000000
  }
  else if (grepl("K",val)){
    val <- gsub("K","", val)
    new_data$Release.Clause[v] = as.numeric(val) * 1000
  }
  else{}
  v <- v+1
}
# convert from euros to dollars
new_data$Release.Clause <-as.numeric(new_data$Release.Clause)
new_data$Release.Clause <- new_data$Release.Clause * 1.06

#remove special characters from W.F.SM, and IR columns
new_data$W.F <- gsub("★","",new_data$W.F)
new_data$W.F <- gsub(" ","",new_data$W.F)
new_data$SM <- gsub("★","",new_data$SM)
new_data$SM <- gsub(" ","",new_data$SM)
new_data$IR <- gsub("★","",new_data$IR)
new_data$IR <- gsub(" ","",new_data$IR)
#Convert W.F, SM,and IR columns to integer
new_data$W.F <-as.integer(new_data$W.F)
new_data$SM <-as.integer(new_data$SM)
new_data$IR <-as.integer(new_data$IR)

#cleaning Hits column
v <<- 1 
for (val in new_data$Hits) {
  
  if (grepl("K",val)){
    val <- gsub("K","", val)
    new_data$Hits[v] = val = as.numeric(val) * 1000
  }
  else{}
  v <- v+1
} 
new_data$Hits <-as.numeric(new_data$Hits)   #convert Hit Column to number
unique(new_data$Hits)
new_data<- new_data %>% #replacing null values in Hits column with 0
  mutate(Hits=if_else(is.na(Hits), 0, Hits))
unique(new_data$Hits)

#Divide BOV, OVA, and POT columns by 100 to change the columns to numeric
#then convert to percentage(%)
new_data$POT<- new_data$POT/100
new_data$X.OVA<- new_data$X.OVA/100
new_data$BOV<- new_data$BOV/100
#convert them to percentage using the "percent" function 
new_data$POT<- percent(new_data$POT, accuracy=1)
new_data$X.OVA<- percent(new_data$X.OVA, accuracy=1)
new_data$BOV<- percent(new_data$BOV, accuracy=1)
view(new_data)

#rename columns
new_data<- new_data %>%
  rename(Full_Name=LongName, Overall_Rating=X.OVA, Potential=POT, Height_cm= Height, Weight_kg=Weight,
         Best_Overall=BOV,Injury_Rating= IR, Pass_Accuracy=PAS, Shooting_Attribute=SHO,Pace=PAC)
#Remove Loan.End.Date column
new_data <- subset(new_data, select = -Loan.Date.End)

#export the cleaned dataset
write.csv(new_data,"C:/Users/Raufr/OneDrive/Desktop/R/Data Cleaning with R//Fifa_data.Cleaned.csv",row.names= FALSE)
