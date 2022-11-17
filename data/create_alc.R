# Data wrangling for student performance data, IODS Assignment 3
# author: Sami Muraja
# 2022-11-14

# loading needed libraries
library(tidyverse)

# Reading the tables
mat <- read.csv("C:/Users/SM/Documents/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
str(mat)
dim(mat)

pt <- read.csv("C:/Users/SM/Documents/IODS-project/data/student-por.csv", sep = ";", header = TRUE)
str(pt)
dim(pt)

#Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers. Keep only the students present in both data sets. Explore the structure and dimensions of the joined data. (1 point)

free <- c("failures", "paid", "absences", "G1", "G2", "G3")
join <- setdiff(colnames(pt), free)
mat_pt <- mat %>% inner_join(pt, by = join, suffix = c(".mat", ".pt"))

str(mat_pt)
dim(mat_pt)

#Get rid of the duplicate records in the joined data set. Either a) copy the solution from the exercise "3.3 The if-else structure" to combine the 'duplicated' answers in the joined data, or b) write your own solution to achieve this task. (1 point)
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

#Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise). (1 point)
alc <- mutate(alc, alc_use = (Walc + Dalc) / 2)

alc <- mutate(alc, high_use  alc_use > 2)
#Glimpse at the joined and modified data to make sure everything is in order. The joined data should now have 370 observations. Save the joined and modified data set to the ‘data’ folder, using for example write_csv() function (readr package, part of tidyverse). (1 point)
alc %>% glimpse
write_csv(alc, "C:/Users/SM/Documents/IODS-project/data/alc.csv")
