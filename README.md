# FIFA-21-Data-Cleaning-Using-R

## Background

This is a data cleaning challenge organized by [ChinosoPromise](https://twitter.com/PromiseNonso_) and [VicSomadina](https://twitter.com/vicSomadina) for data newbies, intermediate, and pro data analysts to test their data cleaning knowledge or to learn how to clean dirty and messy data as the case may be. The uncleaned data was obtained from [Kaggle](https://www.kaggle.com/datasets/yagunnersya/fifa-21-messy-raw-dataset-for-cleaning-exploring)

## About the dataset
The dataset contains information on players who partook in FIFA 2021 football. There are 18979 rows and 77 columns in the datasets. 

## Data Cleaning Process
The notable cleaning performed on the dataset is described below

- The CSV file was loaded into RStudio using the below code:

```r
new_data <- read.csv("C:/Users/Raufr/OneDrive/Desktop/R/Data Cleaning with R/fifa21 raw data v2.csv")
view(new_data)
```
- **Club Column**

This column contains white and trailing spaces so I used the gsub() function to remove white space
```r
-- Removing white spaces from the club column
new_data$Club<- gsub("\\s+", "", new_data$Club)
```
- **Contract column**
 
Contains information about two separate years. The column was used to create a “contract type” column to show if a player is on contract, on loan, or Free.
```r
#Create a Contract_type to indicate if players are on contract, on loan, or free
new_data <- new_data %>%
  mutate(Contract_type = case_when(
    grepl("~",Contract) ~ "Contract",
    grepl("L", Contract) ~ "On Loan",
    grepl("F",Contract) ~ "Free") )
unique(new_data$Contract_type)
```
```r
Fifa_cleaned$LongName <- gsub("[Ã©]","e",Fifa_cleaned$LongName) # Replace J or j with G
Fifa_cleaned$LongName <- gsub("[Ã¼]","ü",Fifa_cleaned$LongName) # Replace S or s with M
Fifa_cleaned$LongName <- gsub("[Ä]","č",Fifa_cleaned$LongName) # Replace M or m with K
Fifa_cleaned$LongName <- gsub("[Ä™]","ę",Fifa_cleaned$LongName) # Replace K or k with L
view(Fifa_cleaned)
```
