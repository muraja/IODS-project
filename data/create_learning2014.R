# description: IODS2022, Assignment 2, Data Wrangling
# author: Sami Muraja
# date: 2022-11-08


# 1.
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)

# 2. 
library(tidyverse)
learning2014 %>% dim() 
  # prints the dimensions of the table: 183 observations and 60 variables
learning2014 %>% str() 
  # prints the variable names and the first observations of that variable

# 3.
learning2014$attitude <- learning2014$Attitude/10
  deep_q <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
learning2014$deep <- rowMeans(learning2014[, deep_q])
  surface_q <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
learning2014$surf <- rowMeans(learning2014[, surface_q])
  strategic_q <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
learning2014$stra <- rowMeans(learning2014[, strategic_q])
learn <- learning2014[, c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")]
colnames(learn)[2] <- "age"
colnames(learn)[7] <- "points"
learn14 <- learn %>% filter(points > 0)
str(learn14) # checking that everything is correct now

# 4. 
setwd("C:\Users\SM\Documents\IODS-project") # set working directory
write_csv(learn14, "C:/Users/SM/Documents/IODS-project/data/learning2014.csv")

# verifying that the file reads correctly
test <- read_csv("C:/Users/SM/Documents/IODS-project/data/learning2014.csv")
test
str(test)
head(test)
