# Human development and gender inequality
# author: Sami Muraja
# original data: https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt

### Assignment 4 ###

library(tidyverse)
# read “Human development” and “Gender inequality” datasets
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables. (1 point)
hd %>% str
hd %>% summary

gii %>% str
gii %>% summary

# renaming the variable names to be shorter
hd %>% names
hd <- hd %>% rename(
  "HDI.r" = "HDI Rank",                          
  "country" = "Country",                            
  "HDI" = "Human Development Index (HDI)",      
  "life.exp" = "Life Expectancy at Birth",        
  "exp.edu" = "Expected Years of Education",           
  "mean.edu" = "Mean Years of Education",           
  "GNI" = "Gross National Income (GNI) per Capita",
  "gni-hdi" = "GNI per Capita Rank Minus HDI Rank"
)

gii %>% names
gii <- gii %>% rename(
  "GII.r" = "GII Rank",                    
  "country" = "Country",
  "GII" = "Gender Inequality Index (GII)",
  "momdeath" = "Maternal Mortality Ratio",
  "teenmom" = "Adolescent Birth Rate",
  "repre" = "Percent Representation in Parliament",
  "eduF" = "Population with Secondary Education (Female)",
  "eduM" = "Population with Secondary Education (Male)",
  "workF" = "Labour Force Participation Rate (Female)",
  "workM" = "Labour Force Participation Rate (Male)" 
)
# Creating 2 new variables to gii: the ratio of 2nd education and labour force participation by gender
gii <- gii %>% mutate(eduRatio = eduF/eduM) %>% mutate(workRatio = workF/workM)

# Joining the datasets using country as the identifier
human <- inner_join(gii, hd, by = "country")
# write_csv(human, "data/human.csv") # outdated in assignment 5


### Assignment 5 ###

#Load the ‘human’ data into R. Explore the structure and the dimensions of the data and describe the dataset briefly, assuming the reader has no previous knowledge of it (this is now close to the reality, since you have named the variables yourself). (0-1 point)
human %>% str
human %>% names
  #  The data contains 19 variables and 195 observations. 

#Mutate the data: transform the Gross National Income (GNI) variable to numeric (using string manipulation). Note that the mutation of 'human' was NOT done in the Exercise Set. (1 point)
human$GNI %>% str # currently integrer
human$GNI <- human$GNI %>% as.numeric
human$GNI %>% str # now numeric

#Exclude unneeded variables: keep only the columns matching the following variable names (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)
keep <- c("country", "eduRatio", "workRatio", "expedu", "lifeexp", "GNI", "momdeath", "teenmom", "repre") # repre was supposed to be female specific?
human <- human %>% select(keep)

#Remove all rows with missing values (1 point).
human <- human %>% filter(complete.cases(human))

#Remove the observations which relate to regions instead of countries. (1 point)
human %>% tail(10) # the last 7 variables refer to regions instead of countries
last <- nrow(human) - 7 # defining the last row to exclude the last 7 rows
human <- human[1:last,] # saving the data without the last 7 rows

#Define the row names of the data by the country names and remove the country name column from the data. The data should now have 155 observations and 8 variables. Save the human data in your data folder including the row names. You can overwrite your old ‘human’ data. (1 point)
rownames(human) <- human$country
human <- human %>% select(-country)
write_csv(human, "data/human.csv")
