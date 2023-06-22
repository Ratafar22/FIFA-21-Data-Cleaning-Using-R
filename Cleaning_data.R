#reading the  dataset
#setwd("C:/Users/Raufr/OneDrive/Desktop/R/Data Cleaning with R")
#unzip("archive.zip")
#load the data
new_data <- read.csv("C:/Users/Raufr/OneDrive/Desktop/R/Data Cleaning with R/fifa21 raw data v2.csv")
#converting lbs to kg
new_data$Weight <- gsub("lbs","",new_data$Weight)
new_data$Weight <- as.numeric(new_data$Weight)
new_data$Weight <- gsub("kg","",new_data$Weight)
new_data$Weight <- as.numeric(new_data$Weight)
view(new_data)
Fifa_cleaned <-new_data %>% 
  mutate(Value=str_replace_all(Value,"[€,K,M]","","000","000000"),
         Wage=str_replace_all(Wage,"[€,K]",""),
         Released.Clause=str_replace_all(Release.Clause,"[€,K]","","000","000000"))
#replace special characters in LongName Column
# Create a sample data frame with a column containing characters to replace
# Use gsub() to replace multiple characters in the "names" column
Fifa_cleaned$LongName <- gsub("[Ã©]","e",Fifa_cleaned$LongName) # Replace J or j with G
Fifa_cleaned$LongName <- gsub("[Ã¼]","ü",Fifa_cleaned$LongName) # Replace S or s with M
Fifa_cleaned$LongName <- gsub("[Ä]","č",Fifa_cleaned$LongName) # Replace M or m with K
Fifa_cleaned$LongName <- gsub("[Ä™]","ę",Fifa_cleaned$LongName) # Replace K or k with L
view(Fifa_cleaned)
# add constant 2 to the Age column to show the current Age
new_data$Age <- new_data$Age + 2
print(new_data$Age)

colnames(new_data)[21] <- "VAlue($)"
colnames(new_data)[22] <- "Wage($)"
colnames(new_data)[23] <- "Released.Clause($)"
colnames(new_data)[14] <- "Height(cm)"
colnames(new_data)[15] <- "Weight(kg)"

#Multiply PAC, SHO, and PAS columns by 0.01 to change the columns to % 
new_data$PAC<- new_data$PAC * 0.01
new_data$SHO<- new_data$SHO * 0.01
new_data$PAS<- new_data$PAS * 0.01