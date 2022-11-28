# Human development and gender inequality
# author: Sami Muraja

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
  "rank" = "HDI Rank",                          
  "country" = "Country",                            
  "HDI" = "Human Development Index (HDI)",      
  "lifeexp" = "Life Expectancy at Birth",        
  "expedu" = "Expected Years of Education",           
  "meanedu" = "Mean Years of Education",           
  "GNI" = "Gross National Income (GNI) per Capita",
  "gni-hdi" = "GNI per Capita Rank Minus HDI Rank"
)

gii %>% names
gii <- gii %>% rename(
  "rank" = "GII Rank",                    
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

#Join together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder. (1 point)
human <- inner_join(gii, hd, by = "country")
write_csv(human, "data/human.csv")
