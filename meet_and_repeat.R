# title: Data wrangling for longitudinal analysis
# author: Sami Muraja

library(tidyverse)
 # 1. Load the data sets (BPRS and RATS) into R using as the source the GitHub repository of MABS, where they are given in the wide form:
  
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")

str(BPRS)
str(RATS)
  # In the wide form data the repeated measures are each on their own columns,
  # which is nicely readable as a human reader but not so nice for the computer.

#2. Convert the categorical variables of both data sets to factors. (1 point)
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. (1 point)
BPRSL <- BPRS %>% 
  pivot_longer(cols = -c(treatment, subject), # converting to long form
               names_to = "weeks", 
               values_to = "bprs") %>% 
  arrange(weeks) %>% # arranging by weeks
  mutate(week = as.integer(substr(weeks,5,5))) %>% # extracting week numbers
  select(-weeks) # removing this as it's replaced by week

RATSL <- RATS %>% 
  pivot_longer(cols = -c(ID, Group), # converting to long form
               names_to = "WD",
               values_to = "weight") %>% 
  arrange(WD) %>% # arranging by WD
  mutate(Time = as.integer(substr(WD, 3, 4))) %>% # extracting day numbers
  select(-WD) # removing this as it's replaced by Time


#4. Now, take a serious look at the new data sets and compare them with their wide form versions: Check the variable names, view the data contents and structures, and create some brief summaries of the variables. Make sure that you understand the point of the long form data and the crucial difference between the wide and the long forms before proceeding the to Analysis exercise. (2 points)
str(BPRSL)
summary(BPRSL)

str(RATSL)
summary(RATSL)

# The long form has all the bprs values in BPRSL and weight values in RATSL
# in the same column, which makes sense as they're really the same variable, but
# it's harder for humans to read. In the long form the different times are coded
# in rows like IDs.

# saving
write_csv(BPRSL, "data/BPRSL.csv")
write_csv(RATSL, "data/RATSL.csv")
