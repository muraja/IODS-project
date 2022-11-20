# Data wrangling for student performance data, IODS Assignment 3
# author: Sami Muraja
# date: 2022-11-14

# loading needed libraries
library(tidyverse)

# Reading the tables
mat <- read.csv("C:/Users/SM/Documents/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
str(mat)
dim(mat)

pt <- read.csv("C:/Users/SM/Documents/IODS-project/data/student-por.csv", sep = ";", header = TRUE)
str(pt)
dim(pt)

# Joining the two data sets using identical variables as identifiers
free <- c("failures", "paid", "absences", "G1", "G2", "G3")
join <- setdiff(colnames(pt), free)
mat_pt <- mat %>% inner_join(pt, by = join, suffix = c(".mat", ".pt"))

str(mat_pt)
dim(mat_pt)

# Removing duplicate records
alc <- select(mat_pt, all_of(join))

for(cname in free) {
  dupl <- select(mat_pt, starts_with(cname))
  col1 <- select(dupl, 1)[[1]]
  if(is.numeric(col1)) {
    alc[cname] <- round(rowMeans(dupl))
  } else {
    alc[cname] <- col1
  }
}
glimpse(alc)

# Creating new columns for alcohol use
alc <- alc %>% 
  mutate(alc_use = (Walc + Dalc) / 2) %>% 
    # average of weekday and weekend alcohol consumption
  mutate(high_use = alc_use > 2)
    # creating a logical column for high alcohol use

# Saving the new data set
alc %>% glimpse
write_csv(alc, "C:/Users/SM/Documents/IODS-project/data/alc.csv")
